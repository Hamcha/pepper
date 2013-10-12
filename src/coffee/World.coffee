window.World = (Game) ->
	self = this

	# Generate 500k stars
	this.stars = generateStars 500000

	# Create and render starfield
	this.starfield = new StarField this.stars
	Game.scene.add this.starfield.particles
	Game.scene.fog = new THREE.Fog 0x000000, 1000, 20000000

	# Ambient lighting (Space is not so dark)
	this.ambientLight = new THREE.AmbientLight 0x606060
	Game.scene.add this.ambientLight

	return this

Star = () ->
	this.id = 0
	this.name = ""
	this.position = new THREE.Vector3 0,0,0

	return this

StarField = (stars) ->
	this.geometry = new THREE.BufferGeometry()
	this.geometry.attributes =
		position:
			itemSize: 3
			array: new Float32Array stars.length * 3
		color:
			itemSize: 3,
			array: new Float32Array stars.length * 3

	this.color = new THREE.Color 0xffffff

	for i in [0...stars.length]
		this.geometry.attributes.position.array[i*3] = stars[i].position.x
		this.geometry.attributes.position.array[i*3+1] = stars[i].position.y
		this.geometry.attributes.position.array[i*3+2] = stars[i].position.z

		this.geometry.attributes.color.array[i*3] = this.color.r
		this.geometry.attributes.color.array[i*3+1] = this.color.g
		this.geometry.attributes.color.array[i*3+2] = this.color.b

	this.geometry.computeBoundingSphere();
	this.material = new THREE.ParticleBasicMaterial { size: 10000, vertexColors: true }
	this.particles = new THREE.ParticleSystem this.geometry, this.material
	this.particles.fog = true

	return this

generateStars = (number) ->
	stars = []
	for i in [0...number]
		star = new Star()
		star.id = i
		star.position = new THREE.Vector3 Math.random()*100000000-50000000, Math.random()*100000000-50000000, Math.random()*100000000-50000000
		star.name = (i%26+10).toString(36).toUpperCase() + (i).toString(16).toUpperCase()
		stars.push star
	return stars