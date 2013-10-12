/**
 * @author mrdoob / http://mrdoob.com/
 */

THREE.PointerLockControls = function ( camera, ship ) {

	var scope = this;

	camera.rotation.set( 0, 0, 0 );

	var pitchObject = new THREE.Object3D();
	pitchObject.add( camera );

	var yawObject = ship;
	yawObject.add( pitchObject );

	var velocity = new THREE.Vector3();

	var PI_2 = Math.PI / 2;

	var onMouseMove = function ( event ) {

		if ( scope.enabled === false || scope.clicking === false ) return;

		var movementX = event.movementX || event.mozMovementX || event.webkitMovementX || 0;
		var movementY = event.movementY || event.mozMovementY || event.webkitMovementY || 0;

		//yawObject.rotation.y -= movementX * 0.002;
		//yawObject.rotation.x -= movementY * 0.002;

		yawObject.rotateOnAxis( new THREE.Vector3(0,1,0), -movementX * 0.002 );
		yawObject.rotateOnAxis( new THREE.Vector3(1,0,0), -movementY * 0.002 );

		//pitchObject.rotation.x = Math.max( - PI_2, Math.min( PI_2, pitchObject.rotation.x ) );

	};

	var onMouseDown = function ( event ) {
		if (event.button !== 2) return;
		if (scope.enabled === false) return;
		askPointerLock();
		scope.clicking = true;
	};

	var onMouseUp = function ( event ) {
		if (event.button !== 2) return;
		if (scope.enabled === false) return;
		document.exitPointerLock();
		scope.clicking = false;
	};

	document.addEventListener( 'mousemove', onMouseMove, false );
	document.addEventListener( 'mousedown', onMouseDown, false );
	document.addEventListener( 'mouseup', onMouseUp, false );

	this.enabled = false;
	this.clicking = false;

	this.getObject = function () {

		return yawObject;

	};

	this.getDirection = function() {

		// assumes the camera itself is not rotated

		var direction = new THREE.Vector3( 0, 0, -1 );
		var rotation = new THREE.Euler( 0, 0, 0, "YXZ" );

		return function( v ) {

			rotation.set( pitchObject.rotation.x, yawObject.rotation.y, 0 );

			v.copy( direction ).applyEuler( rotation );

			return v;

		}

	}();

};
