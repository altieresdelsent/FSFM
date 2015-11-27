domready(function () {
    "use strict";
    var $ = function(sss){return document.querySelector(sss);},
        canvas = $("#visualizeSocial"),
        tools = $("#tools"),
        cleanRectangule = $("#cleanRectangule"),
        isServer = $("#isServer"),
        pedPosio = $("#pedPosio"),
        otherPedPos = $("#otherPedPos"),
        pedVeloc = $("#pedVeloc"),
        otherPedVeloc = $("#otherPedVeloc"),
        DistancePeds = $("#DistancePeds"),
        angleVelocityPed1 = $("#angleVelocityPed1"),
        angleVelocityPed2 = $("#angleVelocityPed2"),
        differenceAngle = $("#differenceAngle"),
        totalVelPed1 = $("#totalVelPed1"),
        totalVelPed2 = $("#totalVelPed2"),
        html = $("html"),
        socialVisualizer = canvas.getContext("2d"),
        Zoom = createZoom(canvas),
        gamma = 0.35,
        n = 2.0,
        n_prime = 3.0,
        lambdaImportance = 2,
        _connection = new WebSocket("ws://localhost:8888"),
        _assyncParser = new Worker("../js/playerWebWorker");

    _connection.onmessage = function _message(msg) {
        _assyncParser.postMessage(msg.data);
    };

    _assyncParser.onmessage = function _messageWorker(msg) {
        var name = "",
            obj = null;
        for(var name in msg.data) {
            obj = msg.data[name]
            if((typeof(obj) === "object")&&(isPointValid(obj))) {
                msg.data[name] = new Point(obj.x,obj.y);
            }
        }
        //var resultSocial = BinaryParser.parseMessage(msg.data);
        processResultSocial(msg.data);
    };

    pedPosio.addEventListener("change",updateSocialForce);
    otherPedPos.addEventListener("change",updateSocialForce);
    pedVeloc.addEventListener("change",updateSocialForce);
    otherPedVeloc.addEventListener("change",updateSocialForce);
    cleanRectangule.addEventListener("click",cleanRect)

    function updateSocialForce() {
        var pedPosition = null,
            otherPosition = null,
            pedVelocity = null,
            otherVelocity = null,
            resultSocial = null,
            name = "",
            inputObj = null,
            float64Server = null;

        if (isAllValid(pedPosio.value,otherPedPos.value,pedVeloc.value,otherPedVeloc.value)) {
            pedPosition = stringToPoint(pedPosio.value);
            otherPosition = stringToPoint(otherPedPos.value);
            pedVelocity = stringToPoint(pedVeloc.value);
            otherVelocity = stringToPoint(otherPedVeloc.value);
            if(isServer.checked) {
                float64Server = new Float64Array(8);
                float64Server[0] = pedPosition.x;
                float64Server[1] = pedPosition.y;
                float64Server[2] = otherPosition.x;
                float64Server[3] = otherPosition.y;
                float64Server[4] = pedVelocity.x;
                float64Server[5] = pedVelocity.y;
                float64Server[6] = otherVelocity.x;
                float64Server[7] = otherVelocity.y;
                _connection.send(float64Server);
            } else {
                resultSocial = socialForce(pedPosition,otherPosition,pedVelocity,otherVelocity);
                processResultSocial(resultSocial);
            }


        }
    }
    function processResultSocial(resultSocial) {
        var name = "",
            inputObj = null,
            pedPosition = stringToPoint(pedPosio.value),
            otherPosition = stringToPoint(otherPedPos.value),
            pedVelocity = stringToPoint(pedVeloc.value),
            otherVelocity = stringToPoint(otherPedVeloc.value);
        for(name in resultSocial) {
            if(resultSocial.hasOwnProperty(name)) {
                inputObj = $("#"+name);
                if((inputObj !== null)&&(inputObj.tagName !== "INPUT")) {
                    inputObj.textContent = JSON.stringify(resultSocial[name],replacer).replace(/[\\"]/g,"");
                }
            }
        }

        drawPedestrian(pedPosition,0.2,"red");
        drawPedestrian(otherPosition,0.2,"blue");

        drawForce(pedPosition,pedVelocity,"#EE0000")
        drawForce(otherPosition,otherVelocity,"#000022");
        drawForce(pedPosition,resultSocial.relativeVelocity,"#EE00EE");
        drawForce(pedPosition,resultSocial.E,"#00EEEE");
        drawForce(pedPosition,resultSocial.interactionVector,"#999900");
        drawForce(pedPosition,resultSocial.result.normalize(),"black");
        drawForce(pedPosition,resultSocial.forceVelocity,"#0000EE");
        drawForce(pedPosition,resultSocial.forceAngle,"#00EE00");
    }
    function replacer(key,value) {
        if(typeof(value) === "number") {
            return (Math.round(value*10000)/10000);
        }
        return value;
    }
    function stringToPoint(str) {
        str = str.replace("x","\"x\"").replace("y","\"y\"");
        var prePoint = JSON.parse(str);
        return new Point(prePoint.x,prePoint.y);
    }
    function isAllValid(arr) {
        var length = arguments.length,
            indice = 0,
            obj = null;
        for(indice = 0; indice < length; indice++) {
            var text = arguments[indice];
            if ((typeof(text) !== "undefined")&&(text !== null)) {
                text = text.replace("x","\"x\"").replace("y","\"y\"");
                obj = TryParseJSONValid(text);
                if (!isPointValid(obj)) {
                    return false;
                }
            } else {
                return false;
            }
        }
        return true;
    }
    function isPointValid(obj) {
        return obj.hasOwnProperty("x") && obj.hasOwnProperty("y");
    }
    function TryParseJSONValid(text) {
        if ((arguments.length > 0)&&(typeof(text) !== "undefined")&&(text !== null)) {
            text = typeof(text) === "string"?text:text.toString();
            try {
                return JSON.parse(text);
            } catch(e) {
                return {};
            }
        }
        return {};
    }
    function drawPedestrian(position, radius,color) {
        var positionInScreen = Zoom.positionInScreen(position),
            radiusInScreen = Zoom.lengthInScreen(radius);

        socialVisualizer.beginPath();
        socialVisualizer.moveTo(positionInScreen.x,positionInScreen.y+radiusInScreen);
        socialVisualizer.arc(positionInScreen.x,positionInScreen.y, radiusInScreen, 0, Math.PI*2, true);
        socialVisualizer.fillStyle = color;
        socialVisualizer.fill();
    }
    function drawForce(positionPed,force,color) {
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

        socialVisualizer.beginPath();
        socialVisualizer.fillStyle = color;
        socialVisualizer.strokeStyle = color;
        socialVisualizer.lineWidth = 2;

        socialVisualizer.moveTo(startCenter.x,startCenter.y);
        socialVisualizer.lineTo(endCenter.x,endCenter.y);

        socialVisualizer.moveTo(startPointer1.x,startPointer1.y);
        socialVisualizer.lineTo(endCenter.x,endCenter.y);

        socialVisualizer.moveTo(startPointer2.x,startPointer2.y);
        socialVisualizer.lineTo(endCenter.x,endCenter.y);

        socialVisualizer.stroke();
        socialVisualizer.closePath();
        socialVisualizer.fill();
    }
    function cleanRect() {
        socialVisualizer.clearRect(0,0,parseFloat(canvas.width),parseFloat(canvas.height));
        updateSocialForce();
    }
    function socialForce(pedPostion,otherPedPosition,pedVeloc,otherVeloc) {
        "use strict";
        var diffe = otherPedPosition.minus(pedPostion),
            distanceBeetweenPeds = diffe.length(),
            attractionDirection = diffe.divide(distanceBeetweenPeds),
            //how much current are moving in relation with pedestrian other
            relativeVelocity = pedVeloc.minus(otherVeloc),
            // If the current are moving in the direction of other interaction vector will be stronger
            //otherwise it will be weaker
            //interactionVector = getInteractionVector(relativeVelocity,attractionDirection)
            interactionVector = relativeVelocity.multiply(lambdaImportance).plus(attractionDirection);

        //get the true distance, discounting the radius of pedestrians
        distanceBeetweenPeds = distanceBeetweenPeds - 0.4;
        //get the length of the interaction, if the pedestrian is moving to the
        // other pedestrian it will be bigger than one, if it's moving away from it
        // it will be less than one
        var interactionLength = interactionVector.length(),
            // get the direction where the interaction is pointing normalized
            interactionDirection = interactionVector.divide(interactionLength),
            //the theta angle is the diference of angle between the "velocity" and the attraction direction
            //the bigger the angle the more the pedestrians are moving away one from another
            angleInteraction = Math.atan2(interactionDirection.y,interactionDirection.x),
            angleDirection = Math.atan2(attractionDirection.y,attractionDirection.x),
            thetaAngle = angleDirection - angleInteraction;
        if (thetaAngle > Math.PI) {
            thetaAngle = thetaAngle - 2*Math.PI;
        } else if (thetaAngle < -Math.PI) {
            thetaAngle = thetaAngle + 2*Math.PI;
        }
        var thetaSign = 1.0;
        if (Math.abs(thetaAngle) > 0.0000001) {
            thetaSign = thetaAngle/Math.abs(thetaAngle);
        }

        //if the pedestrian "current" is moving to the encounter of "other", interactionLength will be bigger
        // and so will be the B parameter
        var B = gamma * interactionLength,
            //if the pedestrian "current" is moving to the encounter of "other", the angle will be closer to 0
            // but be will be bigger, I didn't get why it's like that...
            parameter = (B*thetaAngle);
        //get rid of sign
        parameter = parameter*parameter;

        //FIRST PART -distanceBeetweenPeds/B
        //the closer velocity are to the attraction force the bigger the interaction
        //the bigger the interaction the bigger the B
        //the bigger the B, the lower the "distanceBeetweenPeds/B"
        //the lower the "distanceBeetweenPeds/B" the bigger the force
        //so the bigger the B, the stronger the force,
        //so the bigger the distance, the lower the force
        //so the closer velocity are to the attraction force the bigger the force
        //SECOND PART
        //the bigger the angle the lower the force
        //the bigger the B the lower the force
        //

        var forceVelocityAmount = -Math.exp(-distanceBeetweenPeds/B - (n_prime*n_prime*parameter)),
        //return forceVelocityAmount*-1

        forceAngleAmount = -thetaSign * Math.exp(-distanceBeetweenPeds/B - (n*n*parameter)),

        forceVelocity =  interactionDirection.multiply(forceVelocityAmount),

        interactionDirectionLeft = new Point(-interactionDirection.y, interactionDirection.x),

        forceAngle = interactionDirectionLeft.multiply(forceAngleAmount),

        result = forceVelocity.plus(forceAngle),
        angleVelocityPed1 = atan2Radians(pedVeloc.y,pedVeloc.x),
        angleVelocityPed2 = atan2Radians(otherVeloc.y,otherVeloc.x),
        attractionDirection = diffe.normalize();

        return {
            pedPosio:pedPostion,
            otherPedPos: otherPedPosition,
            pedVeloc: pedVeloc,
            otherPedVeloc:otherVeloc,
            DistancePeds: distanceBeetweenPeds,
            angleVelocityPed1:angleVelocityPed1,
            angleVelocityPed2: angleVelocityPed2,
            differenceAngle : treatAngle(angleVelocityPed2-angleVelocityPed1),
            totalVelPed1: pedVeloc.length(),
            totalVelPed2: otherVeloc.length(),
            relativeVelocity:relativeVelocity,
            totalRelVelPed: relativeVelocity.length(),
            angleRelativeVelocity: atan2Radians(relativeVelocity.y,relativeVelocity.x),
            E:attractionDirection,
            angleE: atan2Radians(attractionDirection.y,attractionDirection.x),
            interactionVector:interactionDirection,
            angleInteractionVector:atan2Radians(interactionDirection.y,interactionDirection.x),
            forceVelocity:forceVelocity,
            forceAngle:forceAngle,
            relationForceAngle:forceVelocityAmount / forceAngleAmount,
            result:result,
            resultAngle:atan2Radians(result.y,result.x)
        };
    }
    function atan2Radians(y,x) {
        return Math.atan2(y,x)/(Math.PI*2);
    }
    function treatAngle(angle) {
        if (angle > Math.PI) {
            angle = angle - 2*Math.PI;
        } else if (angle < -Math.PI) {
            angle = angle + 2*Math.PI;
        }
        return angle;
    }
    function Point(x,y) {
        this.x = x;
        this.y = y;
        this.minus = function(otherPoint) {
            return new Point(this.x - otherPoint.x,
                             this.y - otherPoint.y);
        };
        this.plus = function(otherPoint) {
            return new Point(this.x + otherPoint.x,
                             this.y + otherPoint.y);
        };
        this.multiply = function(scalar) {
            return new Point(this.x * scalar,
                             this.y * scalar);
        };
        this.divide = function(scalar) {
            return new Point(this.x / scalar,
                             this.y / scalar);
        };
        this.length = function() {
            return Math.sqrt((this.x * this.x)+(this.y * this.y));
        };
        this.normalize = function() {
            return this.divide(this.length());
        };
    }
    function alterSize(makeCentral) {
        canvas.width = Math.floor(html.clientWidth*0.49);
        canvas.height = Math.floor(html.clientHeight*0.97);
        canvas.style.width = Math.floor(html.clientWidth*0.49)+"px";
        canvas.style.height = Math.floor(html.clientHeight*0.99)+"px";

        tools.style.left = (Math.floor(html.clientWidth*0.51)+1)+"px"
        tools.style.width = Math.floor(html.clientWidth*0.49)+"px";
        tools.style.height = Math.floor(html.clientHeight*0.99)+"px";
    }
    alterSize();

    var keyCodes = {
        c:67,
        leftArrow:37,
        rightArrow:39,
        spaceBar:32
    };
    window.addEventListener("keydown", function (e) {
        //console.log(e.keyCode);
        if(e.altKey && e.shiftKey && e.keyCode !== 16 && e.keyCode !== 17 && e.keyCode !== 18) {
            //console.log(e.keyCode);
            if(e.keyCode === keyCodes.c) {
                centralize();
            }
        }
    });
    function centralize() {
        var xMax = null,
            yMax = null,
            xMin = null,
            yMin = null,
            pedPosition = null,
            otherPosition = null;
        if (isAllValid(pedPosio.value,otherPedPos.value,pedVeloc.value,otherPedVeloc.value)) {
            pedPosition = stringToPoint(pedPosio.value);
            otherPosition = stringToPoint(otherPedPos.value);

            if(pedPosition.x > otherPosition.x) {
                xMax = pedPosition.x;
                xMin = otherPosition.x;
            } else {
                xMin = pedPosition.x;
                xMax = otherPosition.x;
            }

            if(pedPosition.y > otherPosition.y) {
                yMax = pedPosition.y;
                yMin = otherPosition.y;
            } else {
                yMin = pedPosition.y;
                yMax = otherPosition.y;
            }

            Zoom.centralize(xMax+2, yMax+2, xMin-2, yMin-2);
        }

    }

    centralize();
    updateSocialForce();

});
