window.Utils = Object.create null
loader = new THREE.JSONLoader()

window.Resources =
	"models" : {}
	"audio" : {}

Utils.loadShip = (name, size, cbok) ->
	loader.load "assets/models/ships/"+name+".js", (geometry, materials) ->
		ship = new THREE.Object3D()
		mesh = new THREE.Mesh geometry, new THREE.MeshFaceMaterial materials.map (mat) ->
			if mat.name is "Thrusters" or mat.name is "Glass"
				tlight = new THREE.PointLight mat.color, 0.5, 10
				tlight.position.z = if mat.name is "Thrusters" then size+1 else -size-1
				ship.add tlight
				return new THREE.MeshBasicMaterial mat
			mat.shading = THREE.FlatShading
			return mat
		ship.add mesh
		Resources.models["ships/"+name] = ship
		cbok ship

Utils.loadAudio = (url, cbok) -> 
	Resources.audio[url] = new Audio url+".ogg"
	cbok Resources.audio[url]
