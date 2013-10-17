window.Controls = Object.create null

Controls.init = () ->
	## SETUP MOVEMENT KEYS ##
	document.addEventListener 'mousedown', onClick, false
	document.addEventListener 'keyup',   onKeyUp,   false
	document.addEventListener 'keydown', onKeyDown, false
	document.addEventListener 'focus',   onFocus,   false

	## SETUP CAMERAS ##

	# Create orbit camera
	Game.camera["orbit"] = new THREE.PerspectiveCamera 90, window.innerWidth / window.innerHeight, 0.1, 10000000
	Game.camera["orbit"].position.z = 2
	Game.controls["orbit"] = new THREE.OrbitControls Game.camera["orbit"]
	Resources.models["ships/Fermat"].add Game.camera["orbit"]
	Game.cameras.push "orbit"

	# Create game camera
	Game.camera["cockpit"] = new THREE.PerspectiveCamera 90, window.innerWidth / window.innerHeight, 0.1, 10000000
	Game.camera["cockpit"].position.z = -1
	Game.controls["cockpit"] = new THREE.PointerLockControls Game.camera["cockpit"], Resources.models["ships/Fermat"]
	Game.controls["cockpit"].enabled = true
	Game.cameras.push "cockpit"

	Game.camera["external"] = new THREE.PerspectiveCamera 90, window.innerWidth / window.innerHeight, 0.1, 20000000
	Game.camera["external"].position.y = 8000000
	Game.camera["external"].position.z = 5000000
	Game.camera["external"].rotation.x = -Math.PI * 0.4

	Game.cameratype = "cockpit"

Controls.update = () ->
	return

pressed = {}
onKeyDown = (e) ->
	code = e.which or e.keyCode
	return if pressed[code]? and pressed[code]
	pressed[code] = true
	hk = Hotkeys.filter (x) -> x.key.charCodeAt(0) == code
	for hksingle in hk
		hksingle.callback()

onKeyUp = (e) ->
	code = e.which or e.keyCode
	pressed[code] = false

onFocus = (e) ->
	pressed = {}

onClick = () ->
	return unless event.button == 0
	event.preventDefault()
	document.exitPointerLock() if locked

	clickInfo = { x: 0, y: 0, userHasClicked: false }
	directionVector = new THREE.Vector3()

	clickInfo.x = ( event.clientX / window.innerWidth ) * 2 - 1
	clickInfo.y = - ( event.clientY / window.innerHeight ) * 2 + 1
	clickInfo.userHasClicked = true;

	directionVector.set clickInfo.x, clickInfo.y, 0.1
	directionVector = directionVector.sub(Game.camera[Game.cameratype].position).normalize()
	raycaster = new THREE.Raycaster Game.camera[Game.cameratype].position, directionVector

	frustum = new THREE.Frustum()

	pmax = Game.camera[Game.cameratype].projectionMatrix.clone()
	frustum.setFromMatrix pmax.multiply Game.camera[Game.cameratype].matrixWorldInverse 
	selectedItem = (raycaster.intersectObjects Game.scenes.planetScale.children, false, frustum)[0]

window.askPointerLock = () ->
	document.body.requestPointerLock()