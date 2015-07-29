/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

domready(function () {
    "use strict";
    var currentPedestrian = null,
    canvas = new fabric.StaticCanvas('scene'),    
    createObj = false,
    typeObj = false,
    follow = false,
    followObj = null,
    scene = new Scene(canvas),
    byId = function(id){return document.getElementById(id);};
    
    scene.player.onload = __enableButton;
    
    byId('loadFile').addEventListener('click',loadString);
    
    fabric.Object.prototype.originX = fabric.Object.prototype.originY = 'center';
    
    /* Rresize the canvas to occupy the full page, 
       by getting the widow width and height and setting it to canvas*/
    
    canvas.setDimensions({width:Math.round(window.innerWidth*0.8), height:window.innerHeight});
    window.screen.availWidth - window.screen.availWidth * 0.15;
    canvas.on("object:scaling",onScale);
    canvas.on("object:modified",onChange);
    
    byId('tools').style.left = (window.innerWidth*0.8)+"px";
    byId('up').addEventListener('click',up);
    byId('down').addEventListener('click',down);
    byId('left').addEventListener('click',left);
    byId('right').addEventListener('click',right);
    function exemploAlterarCanvas() {
        this.screenObj.set({
                    left:this.trueX,
                    top:this.trueY,
                    radius:this.trueR
                });
                this.screenObj.setCoords();
    }

    function __update() {        
        this.__canvas.renderAll();
    }
    
    
    byId('play').addEventListener('click',play);
    byId('playBack').addEventListener('click',playBack);
    byId('stop').addEventListener('click',stop);
    byId('next').addEventListener('click',next);
    byId('previous').addEventListener('click',previous);
    
    byId('velocity').addEventListener('click',showVelocity);
    byId('acceleration').addEventListener('click',showAcceleration);
    byId('socialForce').addEventListener('click',showSocialForce);
    byId('socialGranularForce').addEventListener('click',showSocialGranularForce);
    byId('obstacleForce').addEventListener('click',showObstacleForce);
    byId('obstacleGranularForce').addEventListener('click',showObstacleGranularForce);
    byId('desiredForce').addEventListener('click',showDesiredForce);
    byId('lookAheadForce').addEventListener('click',showLookAheadForce);
    
    
    byId('zoom').addEventListener('mousemove',zoom);
    byId('zoom2').addEventListener('mousemove',zoom);
    byId('zoom3').addEventListener('mousemove',zoom);
    
    byId('carregarXml').addEventListener('click',parseToXml);
    
    byId('allll').addEventListener('click',eventOnClick);
    byId('allll').addEventListener('mousemove',followLine);
    
    
    byId('newPedestrianRegion').addEventListener('click',function(event) {
        typeObj = "PedestrianRegion";
        createObj=true;
        event.stopPropagation();
    });
    byId('newObstacle').addEventListener('click',function(event) {
        typeObj = "Obstacle";
        createObj=true;
        event.stopPropagation();
    });
    byId('newWayPoint').addEventListener('click',function(event) {
        typeObj = "WayPoint";
        createObj=true;
        event.stopPropagation();
    });
    byId('newObjective').addEventListener('click',function(event) {
        typeObj = "Objective";
        createObj=true;
        event.stopPropagation();
    });
    byId('SelectPedestrian').addEventListener('click',function(event) {
        typeObj = "SelectPedestrian";
        createObj=true;
        event.stopPropagation();
    });

    function onScale(options) {
        var draw = options.target,
            scale = 0;
            
        if(draw.type === 'circle') {
            scale = (obj.scaleX + obj.scaleY) /2;
            draw.scaleX = 1;
            draw.scaleY = 1;
            draw.setRadius(scale * obj.radius);
            draw.setCoords();
        } else if(draw.type === 'rect') {
            draw.width = draw.width*draw.scaleX;
            draw.height = draw.height*draw.scaleY;
            
            draw.scaleX = 1;
            draw.scaleY = 1;
            draw.setCoords();
        } else if(draw.type === 'line') {
            draw.scaleX = 1;
            draw.scaleY = 1;
            draw.setCoords();
        }
        scene.updateFromScreen();
    }
    
    function onChange(options) {
        var draw = options.target,
        obj = null;
        if(draw.hasOwnProperty("obj")) {
            obj = draw.obj;
            if(obj.hasOwnProperty("updateFromScreen")) {
                obj.updateFromScreen();
            }
        }
        
    }
    
    function eventOnClick(event) {
        var x = event.clientX,
        y = event.clientY,
        obj = null;
//        alert('x:'+x+",y:"+y);
//        return false;
        if(createObj === true) {
            if(typeObj === "PedestrianRegion") {
                
                obj = scene.createPedestrianRegion();
                obj.trueX = x;
                obj.trueY = y;
                obj.trueDX = 40;
                obj.trueDY = 40;
                obj.update();
                canvas.renderAll();
                
            } else if (typeObj === "Obstacle") {
                obj = scene.createObstacle();
                obj.trueX1 = x;
                obj.trueY1 = y;
                obj.trueX2 = x+10;
                obj.trueY2 = y+10;
                
                follow = true;
                followObj = obj;
                obj.update();
                canvas.renderAll();
            } else if (typeObj === "WayPoint") {
                obj = scene.createWayPoint();
                obj.trueX = x;
                obj.trueY = y;
                obj.trueR = 40;
                obj.update();
                canvas.renderAll();
                
            } else if (typeObj === "Objective") {
                obj = scene.createObjective();
                
                obj.trueX = x;
                obj.trueY = y;
                obj.trueR = 20;
                obj.update();
                canvas.renderAll();
                
            } else if (typeObj === "SelectPedestrian") {
                selectPedestrian(x,y);                
            }
            createObj = false;
            typeObj = "";
        } else if(follow === true) {
            follow = false;
            followObj.trueX2 = x;
            followObj.trueY2 = y;
        }  
    }
    
    function followLine(event) {
        var x = event.clientX,
        y = event.clientY;

        if(follow === true) {
            followObj.trueX2 = x;
            followObj.trueY2 = y;
            followObj.update();
            canvas.renderAll();
        }
    }

    function loadString() {
        scene.loadStringXML(byId("file").textContent);
        byId("windowFile").style.display = 'none';
    }    
    
    function update() {
        scene.update();
    }
    
    function parseToXml() {
        scene.updateFromScreen();
        byId("file").innerHTML = scene.toXML();
        byId("windowFile").style.display = "block";
        //var doc=parser.parseFromString(text,'text/xml');
    }
    
    
    function zoom(advancement) {
        var zoomValue = parseFloat(byId('zoom').value) + parseFloat(byId('zoom2').value) + parseFloat(byId('zoom3').value);
        scene.Transform = Math.exp(zoomValue);
    }

    function up() {
        scene.TopChange += parseFloat(byId("change").value);
    }
    
    
    function down() {
        scene.TopChange -= parseFloat(byId("change").value);
    }
    
    
    function left() {
        scene.LeftChange -= parseFloat(byId("change").value);
    }
    
    
    function right() {
        scene.LeftChange += parseFloat(byId("change").value);
    }
    
    
    function loadInformationPedestrian() {
        byId("radius").textContent  = this.r;
        
        byId("position").textContent  = JSON.stringify({x:this.x,y:this.y});
        byId("velocity").textContent  = JSON.stringify(this.velocity);
        byId("acceleration").textContent  = JSON.stringify(this.acceleration);
        byId("socialForce").textContent  = JSON.stringify(this.socialForce);
        byId("socialGranularForce").textContent  = JSON.stringify(this.socialGranularForce);
        byId("obstacleForce").textContent  = JSON.stringify(this.obstacleForce);
        byId("obstacleGranularForce").textContent  = JSON.stringify(this.obstacleGranularForce);
        byId("desiredForce").textContent  = JSON.stringify(this.desiredForce);
        byId("lookAheadForce").textContent  = JSON.stringify(this.lookAheadForce);
        byId("maxVelocity").textContent  = this.maxVelocity;
        byId("active").textContent  = this.active;
        byId("wayPoint").textContent  = JSON.stringify(this.wayPoint);
    }
    
    function selectPedestrian(x,y) {
        var newPedestrian = scene.findPedestrianByPosition({x:x,y:y});
        if( currentPedestrian !== newPedestrian) {
            if(currentPedestrian !== null) {
                currentPedestrian.removeAllForces();
            }
            currentPedestrian = newPedestrian;
            loadInformationPedestrian.call(currentPedestrian);
        }
        
    }
    
    function play () {
        scene.play();
    }
    
    function playBack() {
        scene.playBack();
    }
    
    function stop () {
        scene.stop();
    }
    function next () {
        scene.next();
        if(currentPedestrian !== null) {
            loadInformationPedestrian.call(currentPedestrian);
        }
    }
    function previous () {
        scene.previous();
        if(currentPedestrian !== null) {
            loadInformationPedestrian.call(currentPedestrian);
        }
    }
    
    function showForce(type) {
        this.addForce(type);        
    }
    function showAcceleration() {
        showForce.call(currentPedestrian,"acceleration");
    }
    function showVelocity() {
        showForce.call(currentPedestrian,"velocity");
    }
    function showSocialForce() {
        showForce.call(currentPedestrian,"socialForce");
    }
    function showSocialGranularForce() {
        showForce.call(currentPedestrian,"socialGranularForce");
    }
    function showObstacleForce() {
        showForce.call(currentPedestrian,"obstacleForce");
    }
    function showObstacleGranularForce() {
        showForce.call(currentPedestrian,"obstacleGranularForce");
    }
    function showDesiredForce() {
        showForce.call(currentPedestrian,"desiredForce");
    }
    function showLookAheadForce() {
        showForce.call(currentPedestrian,"lookAheadForce");
    }
    
    function __enableButton() {
        byId("play").disabled = false;
        byId("playBack").disabled = false;
        byId("stop").disabled = false;
        byId("next").disabled = false;
        byId("previous").disabled = false;
    };
    
    
    
    
    
    
    
    function teste() {
        

        // create a rectangle object
        var line = new fabric.Line([0,0,200,200],{
                fill: 'red',
                stroke: 'red',
                strokeWidth: 1
              });

        var circle = new fabric.Circle({
            radius: 20,
            fill: 'green',
            left: 100,
            top: 100
        });
        
        var circ = new fabric.Circle({
            radius: 20,
            fill: 'green',
            left: 100,
            top: 100
        });
        
        var rect = new fabric.Rect({
            left: 100,
            top: 100,
            fill: 'red',
            width: 20,
            height: 20,
            opacity:0.5
          });
        // "add" rectangle onto canvas
        canvas.add(line);
        canvas.add(circ);
        canvas.add(rect);
        
    }
    
    
    //teste();
});
