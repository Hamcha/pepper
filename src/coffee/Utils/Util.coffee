window.filterSingle = (array, func) -> return {id:i,elem:x} for x,i in array when func x

window.pad = (n,z) -> 
	n = n.toString()
	n = "0" + n while n.length < z
	return n

window.monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]