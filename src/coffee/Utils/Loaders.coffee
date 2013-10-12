window.Utils = Object.create null
loader = new THREE.JSONLoader()

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
		cbok ship