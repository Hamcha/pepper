window.filterSingle = (array, func) -> return {id:i,elem:x} for x,i in array when func x

window.pad = (n,z) -> 
	n = n.toString()
	n = "0" + n while n.length < z
	return n

window.monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]

window.rnd_snd = () ->(Math.random()*2-1)+(Math.random()*2-1)+(Math.random()*2-1)

window.worldToScreen = (pos) ->
	[widthHalf,heightHalf] = [WIDTH / 2, HEIGHT / 2]
	vector = new THREE.Vector3()
	projector = new THREE.Projector()
	vector = projector.projectVector pos.clone(), Game.camera[Game.cameratype]
	vector.x = ( vector.x * widthHalf ) + widthHalf
	vector.y = - ( vector.y * heightHalf ) + heightHalf
	return [vector.x,vector.y]

window.whereis = (starid) -> Game.world.stars[starid].position

window.selectBox = (x,y,w,h) ->
	newpos =
		left   : x - w/2
		top    : y - h/2
		width  : w
		height : h
	selection = document.querySelector("#selection")
	selection.style[x] = y + "px" for x,y of newpos