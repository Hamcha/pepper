window.Game = Object.create null
Game.scene = undefined

Game.cameras = []
Game.camera = {}
Game.cameratype = ""

Game.controls = {}
Game.speed = 1.0
Game.meshes = {}

selectedItem = undefined

window.Hotkeys = []

initTJS = () ->
	Math.seedrandom 'hello mr pepper'

	Detector.addGetWebGLMessage() unless Detector.webgl
	container = document.getElementById "container"

	Game.renderer = new THREE.WebGLRenderer()
	Game.renderer.setSize window.innerWidth, window.innerHeight
	Game.renderer.clearAlpha = 1
	container.appendChild Game.renderer.domElement

	window.stats = new Stats();
	stats.domElement.style.position = 'absolute';
	stats.domElement.style.top = '0px';
	container.appendChild stats.domElement

	# Create scene
	Game.scene = new THREE.Scene()

	# Create game world
	Game.world = new World Game

	# Create game clock
	Game.clock = new THREE.Clock()
	Game.clock.start()

	# Setup raycaster for selections
	Game.projector = new THREE.Projector()

	document.addEventListener 'mousedown', onClick, false
	document.addEventListener 'keyup',   onKeyUp,   false
	document.addEventListener 'keydown', onKeyDown, false
	document.addEventListener 'focus',   onFocus,   false
	window.addEventListener 'resize', onWindowResize, false

	# Load main ship
	Utils.loadShip "Fermat", 1, (mesh) ->
		Game.scene.add mesh

		# Create orbit camera
		Game.camera["orbit"] = new THREE.PerspectiveCamera 90, window.innerWidth / window.innerHeight, 0.1, 10000000
		Game.camera["orbit"].position.z = 2
		Game.controls["orbit"] = new THREE.OrbitControls Game.camera["orbit"]
		#Game.controls["orbit"].targetObject = mesh
		mesh.add Game.camera["orbit"]
		Game.cameras.push "orbit"

		# Create game camera
		Game.camera["cockpit"] = new THREE.PerspectiveCamera 90, window.innerWidth / window.innerHeight, 0.1, 10000000
		Game.camera["cockpit"].position.z = -1
		Game.controls["cockpit"] = new THREE.PointerLockControls Game.camera["cockpit"], mesh
		Game.controls["cockpit"].enabled = true
		Game.cameras.push "cockpit"

		Game.cameratype = "cockpit"

		render()

render = () ->
	stats.begin()

	# Ask for next frame
	requestAnimationFrame render

	# Render frame
	Game.renderer.render Game.scene, Game.camera[Game.cameratype] if Game.scene? and Game.camera[Game.cameratype]?
	# Update camera modes
	Game.controls[Game.cameratype].update() if Game.cameratype == "orbit"

	stats.end()

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
	selectedItem = (raycaster.intersectObjects Game.scene.children, false, frustum)[0]

allowed = true
onKeyDown = (e) ->
	return unless allowed
	allowed = false
	code = e.which or e.keyCode
	hk = Hotkeys.filter (x) -> x.key.charCodeAt(0) == code
	for hksingle in hk
		hksingle.callback()

onKeyUp = (e) ->
	allowed = true
onFocus = (e) ->
	allowed = true

onWindowResize = () ->
	Game.camera.aspect = window.innerWidth / window.innerHeight
	Game.camera.updateProjectionMatrix()
	Game.renderer.setSize window.innerWidth, window.innerHeight

window.askPointerLock = () ->
	document.body.requestPointerLock()

locked = false

domready ->
	havePointerLock = ("pointerLockElement" of document) or ("mozPointerLockElement" of document) or ("webkitPointerLockElement" of document)
	document.exitPointerLock = document.exitPointerLock or document.mozExitPointerLock or document.webkitExitPointerLock
	document.body.requestPointerLock = document.body.requestPointerLock or document.body.mozRequestPointerLock or document.body.webkitRequestPointerLock
	if havePointerLock
		pointerlockchange = (event) ->
			if document.pointerLockElement is document.body or document.mozPointerLockElement is document.body or document.webkitPointerLockElement is document.body
				locked = true
			else
				locked = false

		document.addEventListener 'pointerlockchange', pointerlockchange, false
		document.addEventListener 'mozpointerlockchange', pointerlockchange, false
		document.addEventListener 'webkitpointerlockchange', pointerlockchange, false
	else
		startdialog.innerHTML = 'Your browser doesn\'t seem to support Pointer Lock API'

	initTJS()