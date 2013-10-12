window.HUD = Object.create null

HUD.switchCamera = () ->
	Game.controls[Game.cameratype].enabled = false
	Game.cameratype = Game.cameras[(Game.cameras.indexOf(Game.cameratype)+1) % Game.cameras.length]
	Game.controls[Game.cameratype].enabled = true