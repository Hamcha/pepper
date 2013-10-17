preloadList =
	ships: [{url:"Fermat", size:1}]
	audio: ["sfx/Engine", "SadTrombone"]
	textures: [""]

resCount = preloadList.ships.length + preloadList.audio.length

window.Preloader = (cbok) ->
	for s in preloadList.ships
		Utils.loadShip s.url, s.size, () -> checkCompletion cbok
	for a in preloadList.audio
		Utils.loadAudio a, () -> checkCompletion cbok

checkCompletion = (cbok) ->
	resCount -= 1
	if resCount < 1
		document.body.removeChild document.getElementById "loading"
		cbok()