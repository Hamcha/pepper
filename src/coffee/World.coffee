window.World = (Game) ->

	# Create scenes
	Game.scenes.planetScale = new THREE.Scene()
	Game.scenes.starScale = new THREE.Scene()

	@galaxy = new THREE.Object3D()
	Game.scenes.starScale.add @galaxy

	# Generate 500k stars
	@stars = generateStars()
	@starScaleValue = 0.1 

	# Create and render starfield
	@starfield = new StarField @stars, @starScaleValue
	@galaxy.add @starfield.particles
	Game.scenes.starScale.fog = new THREE.Fog 0x000000, 1000, 2000000

	# Ambient lighting (Space is not so dark)
	@ambientLight = new THREE.AmbientLight 0x606060
	Game.scenes.planetScale.add @ambientLight

	return this


Star = () ->
	@id = 0
	@name = ""
	@position = new THREE.Vector3()

	return this

StarField = (stars, scale) ->
	@geometry = new THREE.BufferGeometry()
	@geometry.attributes =
		position:
			itemSize: 3
			array: new Float32Array stars.length * 3
		color:
			itemSize: 3,
			array: new Float32Array stars.length * 3

	@color = new THREE.Color 0xffffff

	for i in [0...stars.length]
		@geometry.attributes.position.array[i*3] = stars[i].position.x * scale
		@geometry.attributes.position.array[i*3+1] = stars[i].position.y * scale
		@geometry.attributes.position.array[i*3+2] = stars[i].position.z * scale

		@geometry.attributes.color.array[i*3] = @color.r
		@geometry.attributes.color.array[i*3+1] = @color.g
		@geometry.attributes.color.array[i*3+2] = @color.b

	@geometry.computeBoundingSphere();
	@material = new THREE.ParticleBasicMaterial { size: 10, vertexColors: true }
	@particles = new THREE.ParticleSystem @geometry, @material
	@particles.fog = true

	return this

# Galaxy generation code by Ben Motz <motzb@hotmail.com>
# Slighter modifications by Hamcha

galaxyOptions =
	numHub   : 300000 	# Stars in the core
	numDisk  : 100000 	# Stars in the disk
	diskRad  : 65000000 # Radius of the disk
	hubRad   : 20000000 # Radius of the core
	numArms  : 6 		# Number of arms
	armRot   : 0.3 		# Winding tightness
	armWidth : 0.15 	# Arm width
	fuzz     : 0.35 	# Max outlier distance from arms
	maxDiskZ : 1500000
	maxHubZ  : 3465000
	focusZone: 0.3

generateStars = () ->
	stars = []
	fullAngle = Math.PI*2
	omega = fullAngle/galaxyOptions.numArms

	for i in [0...galaxyOptions.numDisk]
		fuzz = if i/galaxyOptions.numDisk < galaxyOptions.focusZone then galaxyOptions.fuzz*(i/galaxyOptions.numDisk) else galaxyOptions.fuzz
		dist = (rnd_snd()+1) / 2 * galaxyOptions.diskRad
		theta = (fullAngle * galaxyOptions.armRot * (dist / galaxyOptions.diskRad)) + Math.random()*galaxyOptions.armWidth + omega*Math.floor(Math.random()*galaxyOptions.numArms)+Math.random()*fuzz*2-fuzz
		x = Math.cos(theta)*dist
		y = Math.sin(theta)*dist
		z = rnd_snd() * galaxyOptions.maxDiskZ
		star = new Star()
		star.id = i
		star.position = new THREE.Vector3 x,z,y
		star.name = "D"+(i%26+10).toString(36).toUpperCase() + (i).toString(16).toUpperCase()
		stars.push star

	scale = galaxyOptions.maxHubZ / (galaxyOptions.hubRad * galaxyOptions.hubRad)
	for i in [0...galaxyOptions.numHub]
		dist = rnd_snd() * galaxyOptions.hubRad
		theta = rnd_snd() * fullAngle
		x = Math.cos(theta)*dist
		y = Math.sin(theta)*dist
		z = rnd_snd() * galaxyOptions.maxHubZ
		star = new Star()
		star.id = i
		star.position = new THREE.Vector3 x,z,y
		star.name = "H"+(i%26+10).toString(36).toUpperCase() + (i).toString(16).toUpperCase()
		stars.push star

	return stars