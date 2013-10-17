window.HUD = Object.create null

HUD.switchCamera = () ->
	Game.controls[Game.cameratype].enabled = false
	Game.cameratype = Game.cameras[(Game.cameras.indexOf(Game.cameratype)+1) % Game.cameras.length]
	Game.controls[Game.cameratype].enabled = true

HUD.updateSpeed = () ->
	speedElements = document.querySelectorAll ".speedtoggle > li.selected"
	for i in [0...speedElements.length]
		speedElements[i].className = "speedbtn"
	document.querySelector("#speed"+Math.round(Game.speed)).className = "speedbtn selected"

speedmeter = undefined

HUD.init = () ->
	speedmeter = document.getElementById "currentSpeed"

HUD.update = () ->
	speedmeter.innerHTML = Physics.bodies.playerShip.velocity.length()

HUD.setSpeed = (speed) ->
	Game.speed = speed
	HUD.updateSpeed()