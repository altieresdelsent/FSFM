domready(function () {
    "use strict";
    var byId = function(id){return document.getElementById(id);},
	    $ = function(sss){return document.getElementById(sss);},
	    canvas = byId('testeZoomCanvas'),
	    simulationVideo = canvas.getContext("2d"),
	    path = null,
	    x = 500,
	    y = -200,
	    radius = 4,
	    Zoom = createZoom(canvas),
	    dragging = false;
	
	window.addEventListener("wheel", zoom);
	window.addEventListener("mousemove", drag);
	window.addEventListener("mousedown", function () {
		dragging = true;
	});
	function setDragFalse() {
		dragging = false;
	}
	window.addEventListener("mouseup",setDragFalse);
	window.addEventListener("mouseleave",setDragFalse);
	window.addEventListener("click", testRealPosition);
	window.addEventListener("resize",alterarTamanho);

	function alterarTamanho() {
		canvas.width = window.innerWidth*0.9;
		canvas.height = window.innerHeight*0.9;
		canvas.style.width = window.innerWidth*0.9;
		canvas.style.height = window.innerHeight*0.9;
	}
    
    function zoom(e) {
    	var teste = e,
    		yZ = e.deltaY,
    		grows = (Math.abs(yZ)/yZ === -1);
    	Zoom.zoom(grows);
    }
    function drag(e) {
    	var hasMozzilaMovement = !!e.mozMovementX || !!e.mozMovementY,
    	haswebkitMovement = !!e.webkitMovementX || !!e.webkitMovementY,
    	hasMovement = !!e.movementX || !!e.movementY,
    	movementX = (hasMovement)? e.movementX:(hasMozzilaMovement)?e.mozMovementX:(haswebkitMovement)?e.webkitMovementX:0,
    	movementY = (hasMovement)? e.movementY:(hasMozzilaMovement)?e.mozMovementY:(haswebkitMovement)?e.webkitMovementY:0;
    	if ((e.buttons & 1) || (e.button !== 0) || dragging) {
	    	Zoom.moveX(movementX);
	    	Zoom.moveY(movementY);
	    }
    }
    function testRealPosition() {
    	var position = Zoom.realPosition(Zoom.positionInScreen({x:x,y:y}));
    	alert("{x:"+position.x+",y:"+position.y+"}");
    }
    function animate() {
    	drawCircle(x,y,radius);
	    requestAnimationFrame(animate);
	}
	function drawCircle(x,y,radius) {
		initializeFrame();
		drawPedestrian(x,y,radius);
		finalizeFrame();
	}

	function drawPedestrian(x,y,radius) {
		var radiusScreen = Zoom.lengthInScreen(radius),
			positionInScreen = Zoom.positionInScreen({x:x,y:y});
        simulationVideo.arc(positionInScreen.x, positionInScreen.y, radiusScreen, 0, Math.PI*2, true);
        simulationVideo.fill();
    }
    function initializeFrame() {
        simulationVideo.clearRect(0,0,parseFloat(canvas.width),parseFloat(canvas.height));
        simulationVideo.beginPath();
    }
    function finalizeFrame() {
        simulationVideo.closePath();
    }
    alterarTamanho();
	animate();

});