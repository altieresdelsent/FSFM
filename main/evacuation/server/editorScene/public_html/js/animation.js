domready(function () {
    "use strict";
    var currentPedestrian = null,
    createObj = false,
    typeObj = false,
    follow = false,
    followObj = null,
    byId = function(id){return document.getElementById(id);},
    $ = function(sss){return document.querySelector(sss);},
    canvas = byId('simulation'),
    canvasScene = byId('scene'),
    footer = byId('footer'),
    tools = byId('tools'),
    simulationVideo = canvas.getContext("2d"),
    sceneCtx = canvasScene.getContext("2d"),
    path = null,
    Zoom = createZoom(canvas),
    dragging = false,
    player = new Player(),
    updateScene = true,
    idZoom = null,
    html = $("html"),
    scene = null,
    simulation = null,
    isWaitingToLoad = true;


    player.onconnected = function () {
        player.open(videoName);
    };

    player.onanimationframe = function (frame) {
        var pedestriansArr = BinaryParser.parseFrame(frame);

        simulation.updatePedestrians(pedestriansArr);
        drawSimulation();
        if(updateScene === true) {
            updateScene = false;
            redrawScene(scene);
        }
    };

    player.onblockreceived = function () {

    };

    player.onstopped = function (reason) {
        if (reason === Player.StopReason.VideoHasFinished) {

        } else if(reason === Player.StopReason.VideoIsLoading) {
            showLoading();
        }
        byId("next").disabled = false;
        byId("previous").disabled = false;
    };

    player.beforecontinue = function () {
        hideLoading();
    };

    player.onloadfile = function (initialFrame) {
        var sceneArr = BinaryParser.parseInitialFrame(initialFrame),
            pedestriansRegions = BinaryParser.parsePedestriansRegions(sceneArr[0]),
            pedestrians = BinaryParser.parsePedestrians(sceneArr[1]),
            obstacles = BinaryParser.parseObstacles(sceneArr[2]),
            waypoints = BinaryParser.parseWaypoints(sceneArr[3]),
            objectives = BinaryParser.parseObjectives(sceneArr[4]);

            scene = new Scene(videoName, pedestriansRegions, obstacles, waypoints, objectives);
            simulation = new Simulation(videoName,pedestrians);
            //when alter the canvas size to fit window size perfectly
            //draw automatically the scene and the first frame in the simulation.
            alterSize(true);
            hideLoading();
            enableAllButtons();
    };
    player.onclose = function () {

    };

    //##########################################################
    //############ Window management part ######################

    //workaround because whoever develop nodeList interface is stupid.
    var arrayMethods = Object.getOwnPropertyNames( Array.prototype );

    arrayMethods.forEach( function attachArrayMethodsToNodeList(methodName) {
        try {
            if(methodName !== "length") {
                NodeList.prototype[methodName] = Array.prototype[methodName];
            }
        } catch(e) {
            console.log("Error when try introduce function:"+methodName+". \n"+e.message);
        }
    });
    function playButton() {
        player.play();
        byId("next").disabled = true;
        byId("previous").disabled = true;
    }
    byId("play").addEventListener("click", playButton);

    function nextButton() {
        player.next();
    }
    byId("next").addEventListener("click",nextButton);

    byId("playBack").addEventListener("click", function() {
        player.playBack();
        byId("next").disabled = true;
        byId("previous").disabled = true;
    });

    function previousButton() {
        player.previous();
    }

    byId("previous").addEventListener("click", previousButton);
    function stopButton() {
        player.stop();
        byId("next").disabled = false;
        byId("previous").disabled = false;
    }
    byId("stop").addEventListener("click",stopButton);

    byId("moreSpeed").addEventListener("click",function moreSpeedButton() {
        player.Speed = player.Speed+1;
        byId("speed").value = player.Speed;
    });

    byId("speed").addEventListener("change",function changeSpeed() {
        var speed = parseInt(this.value);
        player.Speed = (speed === speed)?1:speed;
        this.value = player.Speed;
    });

    byId("lessSpeed").addEventListener("click",function lessSpeedButton() {
        player.Speed = player.Speed-1;
        byId("speed").value = player.Speed;
    });

    function alterSize(makeCentral) {
        canvas.width = Math.round(html.clientWidth*0.8);
        canvas.height = Math.round(html.clientHeight*0.97);
        canvas.style.width = Math.round(html.clientWidth*0.8)+"px";
        canvas.style.height = Math.round(html.clientHeight*0.97)+"px";

        canvasScene.width = canvas.width;
        canvasScene.height = canvas.height;
        canvasScene.style.width = canvas.style.width;
        canvasScene.style.height = canvas.style.height;

        footer.style.top = (Math.round(html.clientHeight*0.97)+1)+"px";
        footer.style.height = Math.round(html.clientHeight*0.029)+"px";
        footer.style.width = Math.round(html.clientWidth*0.79)+"px";

        tools.style.left = (Math.round(html.clientWidth*0.8)+1)+"px"
        tools.style.width = Math.round(html.clientWidth*0.19)+"px";
        tools.style.height = Math.round(html.clientHeight*0.99)+"px";

        updateScene = true;
        if((scene !== null)&&(simulation !== null)) {
            if((arguments.length === 1) && (makeCentral === true)) {
                centralize();
            }
            registerDrawAgainEvent();
        }
    }
    function showLoading() {
        var loadingDiv = byId("blockApp"),
        svgLoad = byId("loadAnimation");
        loadingDiv.style.display = "block";
        svgLoad.width = Math.round(html.clientWidth);
        svgLoad.height = Math.round(html.clientHeight);
        isWaitingToLoad = true;

    }

    function hideLoading() {
        var loadingDiv = byId("blockApp");
        loadingDiv.style.display = "none";
        isWaitingToLoad = false;
    }

    function enableAllButtons() {
        document.querySelectorAll("[type=button]").forEach(function(button) {
            button.disabled = false;
        });
    }
    function disableAllButtons() {
        document.querySelectorAll("[type=button]").forEach(function(button) {
            button.disabled = true;
        });
    }

    window.addEventListener("resize",alterSize);

    canvas.addEventListener("mousedown",function pedestrianInformation(e) {
        var currentPedestrian = null,
            realPosition = {x:0,y:0};
        if(simulation !== null) {
            //realPosition = Zoom.positionInScreen(Zoom.realPosition({x:e.clientX, y:e.clientY}));
            //sceneCtx.beginPath();
            //sceneCtx.moveTo(e.clientX,e.clientY+10);
            //sceneCtx.arc(e.clientX,e.clientY, 10, 0, Math.PI*2, true);
            //sceneCtx.fillStyle = "black";
            //sceneCtx.fill();

            //simulationVideo.beginPath();
            //simulationVideo.moveTo(realPosition.x,realPosition.y+10);
            //simulationVideo.arc(realPosition.x,realPosition.y, 10, 0, Math.PI*2, true);
            //simulationVideo.fillStyle = "yellow";
            //simulationVideo.fill();

            realPosition = Zoom.realPosition({x:e.clientX, y:e.clientY});
            currentPedestrian = simulation.findPedestrianByPosition(realPosition);
            //console.log(currentPedestrian.id)
            player.CurrentPedestrianID = currentPedestrian.id;
        }
    });

    byId("cleanForces").addEventListener("click",function cleanForces() {
        player.clearCurrentePedestrian();
    });



    //**********************************************************
    //**********************************************************



    //#########################################################
    //################ Draw Scene part ###########################


    function redrawScene() {
        sceneCtx.clearRect(0,0,parseFloat(canvasScene.width),parseFloat(canvasScene.height));

        sceneCtx.globalAlpha = 0.4;
        drawObstacles(scene.obstacles);
        drawPedestrianRegions(scene.pedestrianRegions);
        drawWaypoints(scene.waypoints);
        drawObjectives(scene.objectives);
    }

    function drawObstacles(obstacles) {
        var indice = 0,
        obstacle = null;
        sceneCtx.fillStyle = "red";
        sceneCtx.strokeStyle = "red";
        sceneCtx.beginPath();
        for(indice = 0; indice < obstacles.length; indice++) {
            obstacle = obstacles[indice]
            drawObstacle(obstacle.start, obstacle.ender);
        }
        sceneCtx.stroke();
        sceneCtx.closePath();
    }

    function drawObstacle(start, ender) {
        var startInScreen = Zoom.positionInScreen(start),
            enderInScreen = Zoom.positionInScreen(ender);

        sceneCtx.moveTo(startInScreen.x,startInScreen.y);
        sceneCtx.lineTo(enderInScreen.x,enderInScreen.y);


    }

    function drawPedestrianRegions(pedestrianRegions) {
        var indice = 0,
            pedestrianRegion = null;
        for(indice = 0; indice < pedestrianRegions.length; indice++) {
            pedestrianRegion = pedestrianRegions[indice]
            drawPedestrianRegion(pedestrianRegion.position, pedestrianRegion.width,pedestrianRegion.height);
        }
    }

    function drawPedestrianRegion(position,width, height) {
        var positionInScreen = Zoom.positionInScreen({x:(position.x - (width*0.5)),
                y:(position.y + (height*0.5))}),
            widthInScreen = Zoom.lengthInScreen(width),
            heightInScreen = Zoom.lengthInScreen(height);

        sceneCtx.beginPath();
        sceneCtx.fillStyle = "gray";
        sceneCtx.fillRect(positionInScreen.x, positionInScreen.y, widthInScreen, heightInScreen);

    }

    function drawWaypoints(waypoints) {
        var indice = 0,
            waypoint = null;

        for(indice = 0; indice < waypoints.length; indice++) {
            waypoint = waypoints[indice]
            drawWaypoint(waypoint.position, waypoint.radius);
        }
    }

    function drawWaypoint(position,radius) {
        var positionInScreen = Zoom.positionInScreen(position),
            radiusInScreen = Zoom.lengthInScreen(radius);


        sceneCtx.beginPath();
        sceneCtx.moveTo(positionInScreen.x,positionInScreen.y+radiusInScreen);
        sceneCtx.arc(positionInScreen.x,positionInScreen.y, radiusInScreen, 0, Math.PI*2, true);
        sceneCtx.fillStyle = "green";
        sceneCtx.fill();
    }

    function drawObjectives(objectives) {
        var indice = 0,
            objective = null;
        for(indice = 0; indice < objectives.length; indice++) {
            objective = objectives[indice]
            drawObjective(objective.position, objective.radius);
        }
    }

    function drawObjective(position,radius) {
        var positionInScreen = Zoom.positionInScreen(position),
            radiusInScreen = Zoom.lengthInScreen(radius);

        sceneCtx.beginPath();
        sceneCtx.moveTo(positionInScreen.x,positionInScreen.y+radiusInScreen);
        sceneCtx.arc(positionInScreen.x,positionInScreen.y, radiusInScreen, 0, Math.PI*2, true);
        sceneCtx.fillStyle = "blue";
        sceneCtx.fill();

    }

    //***********************************************************
    //************** END Draw Scene part **************

    //#########################################################
    //############## START Draw Simulation ##################
    function drawSimulation() {
        var positionPed = null,
            forces = null;
        simulationVideo.clearRect(0,0,parseFloat(canvas.width),parseFloat(canvas.height));
        simulationVideo.globalAlpha = 0.7;
        drawPedestrians(simulation.pedestrians);
        if((player.CurrentPedestrianID !== -1)&&(player.IsInformationAvailable)) {
            console.log(player.CurrentPedestrianID);
            console.log("starting updating forces in screen.");
            simulation.updateForces(player.getCurrentInformation());

            forces = simulation.forces
            positionPed = simulation.pedestrians[player.CurrentPedestrianID -1].position;

            drawForce(positionPed,forces.social);
            drawForce(positionPed,forces.socialGranular);
            drawForce(positionPed,forces.obstacle);
            drawForce(positionPed,forces.obstacleGranular);
            drawForce(positionPed,forces.desired);

            byId("social").textContent = " x:" + forces.social.x+"\n y:"+forces.social.y;
            byId("socialGranular").textContent = " x:" + forces.socialGranular.x+"\n y:"+forces.socialGranular.y;
            byId("obstacle").textContent = " x:" + forces.obstacle.x+"\n y:"+forces.obstacle.y;
            byId("obstacleGranular").textContent = " x:" + forces.obstacleGranular.x+"\n y:"+forces.obstacleGranular.y;
            byId("desired").textContent = " x:" + forces.desired.x+"\n y:"+forces.desired.y;
        }
    }

    function drawPedestrians(pedestrians) {
        var indice = 0,
            pedestrian = null;
        for(indice = 0; indice < pedestrians.length; indice++) {
            pedestrian = pedestrians[indice]
            drawPedestrian(pedestrian.position, pedestrian.radius, pedestrian.color);
        }
    }

    function drawPedestrian(position, radius,color) {
        var positionInScreen = Zoom.positionInScreen(position),
            radiusInScreen = Zoom.lengthInScreen(radius);

        simulationVideo.beginPath();
        simulationVideo.moveTo(positionInScreen.x,positionInScreen.y+radiusInScreen);
        simulationVideo.arc(positionInScreen.x,positionInScreen.y, radiusInScreen, 0, Math.PI*2, true);
        simulationVideo.fillStyle = color;
        simulationVideo.fill();
    }

    function drawForce(positionPed,force) {
        var pedRealPosition = Zoom.positionInScreen(positionPed),
            projection = {x:Zoom.lengthInScreen(force.x),y:-Zoom.lengthInScreen(force.y)},
            startCenter = {x:0,y:0},
            endCenter = {x:0,y:0},
            pointer = {x:0,y:0},
            startPointer = {x:0,y:0},
            movePointer90Degrees = {x:0,y:0},
            startPointer1 = {x:0,y:0},
            startPointer2 = {x:0,y:0};

        startCenter.x = pedRealPosition.x;
        startCenter.y = pedRealPosition.y;

        endCenter.x = startCenter.x + projection.x;
        endCenter.y = startCenter.y + projection.y;

        pointer.x = projection.x / 10;
        pointer.y = projection.y / 10;

        startPointer.x = endCenter.x - pointer.x;
        startPointer.y = endCenter.y - pointer.y;

        movePointer90Degrees.x = -pointer.y;
        movePointer90Degrees.y = pointer.x;

        startPointer1.x = startPointer.x + (movePointer90Degrees.x * 0.5);
        startPointer1.y = startPointer.y + (movePointer90Degrees.y * 0.5);

        startPointer2.x = startPointer.x - (movePointer90Degrees.x * 0.5);
        startPointer2.y = startPointer.y - (movePointer90Degrees.y * 0.5);

        simulationVideo.fillStyle = force.color;
        simulationVideo.strokeStyle = force.color;

        simulationVideo.moveTo(startCenter.x,startCenter.y);
        simulationVideo.lineTo(endCenter.x,endCenter.y);

        simulationVideo.moveTo(startPointer1.x,startPointer1.y);
        simulationVideo.lineTo(endCenter.x,endCenter.y);

        simulationVideo.moveTo(startPointer2.x,startPointer2.y);
        simulationVideo.lineTo(endCenter.x,endCenter.y);

        simulationVideo.stroke();
        simulationVideo.closePath();
    }

    function initializeFrame() {
        simulationVideo.clearRect(0,0,parseFloat(canvas.width),parseFloat(canvas.height));
    }

    function finalizeFrame() {
        simulationVideo.closePath();
    }


    //***********************************************************
    //************* END Draw Simulation *********************

    //#########################################################
    //############## START Do Animation ##################

    //***********************************************************
    //************* END Do Animation *********************

    //###################################
    //########   ZOOM PART ##################
    window.addEventListener("wheel", function zoom(e) {
        var teste = e,
            yZ = e.deltaY,
            grows = (Math.abs(yZ)/yZ === -1);
        Zoom.zoom(grows);
        updateScene = true;
        registerDrawAgainEvent();
    });

    window.addEventListener("mousemove", function drag(e) {
        var hasMozzilaMovement = !!e.mozMovementX || !!e.mozMovementY,
        haswebkitMovement = !!e.webkitMovementX || !!e.webkitMovementY,
        hasMovement = !!e.movementX || !!e.movementY,
        movementX = (hasMovement)? e.movementX:(hasMozzilaMovement)?e.mozMovementX:(haswebkitMovement)?e.webkitMovementX:0,
        movementY = (hasMovement)? e.movementY:(hasMozzilaMovement)?e.mozMovementY:(haswebkitMovement)?e.webkitMovementY:0;
        if ((e.buttons & 1) || (e.button !== 0) || dragging) {
            Zoom.moveX(movementX);
            Zoom.moveY(movementY);
            updateScene = true;
            registerDrawAgainEvent();
        }
    });

    window.addEventListener("mousedown", function () {
        dragging = true;
    });

    function setDragFalse() {
        dragging = false;
    }

    window.addEventListener("mouseup",setDragFalse);
    window.addEventListener("mouseleave",setDragFalse);
    function registerDrawAgainEvent() {
        if(player.hasStopped) {
            if(idZoom !== null) {
                cancelAnimationFrame(idZoom);
            }
            idZoom = requestAnimationFrame(drawAgain);
        }
    }
    function drawAgain() {
        idZoom = null;
        if(player.hasStopped) {
            redrawScene();
            drawSimulation();

        }
    }

    function centralize() {
        var infos = [],
            info = null;

        function reducePedestrian(info, obj) {
            if (info.xMax < (obj.position.x)) {
                info.xMax = obj.position.x;
            }

            if (info.yMax < (obj.position.y)) {
                info.yMax = obj.position.y;
            }

            if (info.xMin > (obj.position.x)) {
                info.xMin = (obj.position.x);
            }

            if (info.yMin > (obj.position.y)) {
                info.yMin = (obj.position.y);
            }
            return info;
        }

        function reduceWayAndObj(info, obj) {
            if (info.xMax < (obj.position.x + obj.radius)) {
                info.xMax = obj.position.x + obj.radius;
            }

            if (info.yMax < (obj.position.y + obj.radius)) {
                info.yMax = obj.position.y + obj.radius;
            }

            if (info.xMin > (obj.position.x - obj.radius)) {
                info.xMin = (obj.position.x - obj.radius);
            }

            if (info.yMin > (obj.position.y - obj.radius)) {
                info.yMin = (obj.position.y - obj.radius);
            }
            return info;
        }

        function reduceObstacle(info, obj) {
            if (info.xMax < obj.start.x) {
                info.xMax = obj.start.x;
            }

            if (info.yMax < obj.start.y) {
                info.yMax = obj.start.y;
            }

            if (info.xMin > obj.start.x) {
                info.xMin = obj.start.x;
            }

            if (info.yMin > obj.start.y) {
                info.yMin = obj.start.y;
            }

            if (info.xMax < obj.ender.x) {
                info.xMax = obj.ender.x;
            }

            if (info.yMax < obj.ender.y) {
                info.yMax = obj.ender.y;
            }

            if (info.xMin > obj.ender.x) {
                info.xMin = obj.ender.x;
            }

            if (info.yMin > obj.ender.y) {
                info.yMin = obj.ender.y;
            }
            return info;
        }

        info = scene.pedestrianRegions.reduce(reducePedestrian,
            {xMax:-Math.pow(2,32),
            yMax:-Math.pow(2,32),
            xMin:Math.pow(2,32),
            yMin:Math.pow(2,32)});
        infos.push(info);

        info = scene.obstacles.reduce(reduceObstacle,
            {xMax:-Math.pow(2,32),
            yMax:-Math.pow(2,32),
            xMin:Math.pow(2,32),
            yMin:Math.pow(2,32)});
        infos.push(info);

        info = scene.waypoints.reduce(reduceWayAndObj,
            {xMax:-Math.pow(2,32),
            yMax:-Math.pow(2,32),
            xMin:Math.pow(2,32),
            yMin:Math.pow(2,32)});
        infos.push(info);

        info = scene.objectives.reduce(reduceWayAndObj,
            {xMax:-Math.pow(2,32),
            yMax:-Math.pow(2,32),
            xMin:Math.pow(2,32),
            yMin:Math.pow(2,32)});
        infos.push(info);

        info = infos.reduce(function(info,obj) {
            if (info.xMax < obj.xMax) {
                info.xMax = obj.xMax;
            }

            if (info.yMax < obj.yMax) {
                info.yMax = obj.yMax;
            }

            if (info.xMin > obj.xMin) {
                info.xMin = obj.xMin;
            }

            if (info.yMin > obj.yMin) {
                info.yMin = obj.yMin;
            }
            return info;
        },
            {xMax:-Math.pow(2,32),
            yMax:-Math.pow(2,32),
            xMin:Math.pow(2,32),
            yMin:Math.pow(2,32)});

        Zoom.centralize(info.xMax, info.yMax, info.xMin, info.yMin);
        registerDrawAgainEvent();
    }


    //#***********************************************************
    //**********************************************************


    //############################################################
    //############### Hot key part ################################
    var keyCodes = {
        c:67,
        leftArrow:37,
        rightArrow:39,
        spaceBar:32
    };
    window.addEventListener("keydown", function (e) {
        console.log(e.keyCode);
        if(e.altKey && e.shiftKey && e.keyCode !== 16 && e.keyCode !== 17 && e.keyCode !== 18) {
            console.log(e.keyCode);
            if(e.keyCode === keyCodes.c) {
                centralize();
            } else if(e.keyCode === keyCodes.rightArrow) {
                nextButton();
            } else if(e.keyCode === keyCodes.leftArrow) {
                previousButton();
            }
        } else if(!e.altKey && !e.shiftKey && !e.ctrlKey && e.keyCode === keyCodes.spaceBar) {
            if(player.hasStopped) {
                playButton();
            } else {
                stopButton();
            }
        }
    });
    //************************************************************
    //************************************************************
});
