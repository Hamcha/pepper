window.Physics = Object.create null

Physics.Body = (mesh) ->
	scope = this
	@mesh = mesh
	@position = new THREE.Vector3()
	@velocity = new THREE.Vector3()
	@acceleration = new THREE.Vector3()
	return this

Physics.bodies = {}
Physics.interval = 20
Physics.delta = 1/Physics.interval

Physics.init = () ->
	setInterval Physics.update, Physics.interval

Physics.jitterThreshold = 20000

Physics.update = () ->
	# Check for threshold
	if Physics.bodies.playerShip.position.length() > Physics.jitterThreshold
		Game.scenes.planetScale.position.sub Physics.bodies.playerShip.position.clone()
		Physics.bodies.playerShip.position.set 0,0,0
	# Apply acceleration and velocity
	for bid,body of Physics.bodies
		body.velocity.add body.acceleration.clone().multiplyScalar Physics.delta*Game.speed
		body.position.add body.velocity.clone().multiplyScalar Physics.delta*Game.speed
		body.mesh.position = body.position