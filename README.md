# Mr. Pepper

Frontier-inspired Space simulator

## Build instructions ##

All Coffeescript and SASS files are compiled using Grunt modules.
You can install them (if you have Node.js and NPM installed) by writing:

	npm install

To build all the files, just use

	grunt build

Or, if you want to develop for Pepper you can create a live-reloading static server by using

	grunt server

### .OBJ -> .JS converter

Into the /src/obj folder there is a very nice Python script wrote by [AlteredQualia](http://alteredqualia.com) for converting models from .OBJ/.MTL to Three.js's internal JSON format.

You can use it with the "convert.cmd" script in the root folder in the following format

	convert FILENAME

Will convert the file /src/obj/FILENAME.obj to /assets/models/FILENAME.js