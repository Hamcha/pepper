window.Game = Object.create null
Game.scenes = {}

Game.cameras = []
Game.camera = {}
Game.cameratype = ""

Game.controls = {}
Game.speed = 1.0

Game.delta = 0
Game.date = +new Date 4200,0,1,0,0,0,0

selectedItem = undefined
hudDate = undefined

window.WIDTH = window.innerWidth
window.HEIGHT = window.innerHeight

initTJS = () ->
	Math.seedrandom 'hello mr pepper'

	Detector.addGetWebGLMessage() unless Detector.webgl
	container = document.getElementById "container"
	window.worlddate = document.querySelector "#worlddate"
	window.worldtime = document.querySelector "#worldtime"

	Game.renderer = new THREE.WebGLRenderer {preserveDrawingBuffer : true}
	Game.renderer.setSize WIDTH, HEIGHT
	Game.renderer.autoClear = false
	container.appendChild Game.renderer.domElement

	window.stats = new Stats();
	stats.domElement.style.position = 'absolute';
	stats.domElement.style.top = '0px';
	container.appendChild stats.domElement

	# Update HUD
	HUD.init()

	# Create game world
	Game.world = new World Game

	# Create game clock
	Game.clock = new THREE.Clock()
	Game.clock.start()

	hudDate = document.querySelector '#hudDate'

	# Set speed UI
	HUD.updateSpeed()

	# Setup raycaster for selections
	Game.projector = new THREE.Projector()

	window.addEventListener 'resize', onWindowResize, false

	# Initialize Physics
	Physics.init()

	# Load main ship
	Game.scenes.planetScale.add Resources.models["ships/Fermat"]
	Physics.bodies["playerShip"] = new Physics.Body Resources.models["ships/Fermat"]

	Controls.init()

	render()

render = () ->
	stats.begin()

	# Update controls
	Controls.update()

	# Update game clock
	Game.updateClock()

	# Update HUD
	HUD.update()

	# Ask for next frame
	requestAnimationFrame render

	# Clear buffer
	Game.renderer.clear true,true,true

	# Render frame
	Game.renderer.render Game.scenes.starScale, Game.camera[Game.cameratype]
	Game.renderer.render Game.scenes.planetScale, Game.camera[Game.cameratype]
	# Update camera modes
	Game.controls[Game.cameratype].update() if Game.cameratype == "orbit"

	stats.end()

currentSpeed = "speed1"
Game.updateClock = () ->
	Game.delta = Game.clock.getDelta() * Game.speed
	Game.date += Game.delta * 1000
	datetime = new Date(Game.date);
	worlddate.innerHTML = [pad(datetime.getDate(),2), monthNames[datetime.getMonth()].substr(0,3), datetime.getFullYear()].join(" ");
	worldtime.innerHTML = [pad(datetime.getHours(),2), pad(datetime.getMinutes(),2), pad(datetime.getSeconds(),2)].join(":");

onWindowResize = () ->
	Game.camera.aspect = window.innerWidth / window.innerHeight
	Game.camera.updateProjectionMatrix()
	Game.renderer.setSize window.innerWidth, window.innerHeight
	WIDTH = window.innerWidth
	HEIGHT = window.innerHeight

window.locked = false

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
	Preloader initTJS