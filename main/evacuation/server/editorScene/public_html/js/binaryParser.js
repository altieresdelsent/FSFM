BinaryParser = {
	stringDecoder : new TextDecoder("utf-8", {fatal: true}),
	loadFromBinary: function() {

	},
	parseInitialFrame: function(frame) {
		"use strict";
		var lengthPedestrianRegionObj = 5,
			lengthPedestrianObj = 6,
			lengthObstacleObj = 4,
			lengthWaypointObj = 3,
			lengthObjectiveObj = 3,
			initialFrame = frame,

			bufferPedestrianRegionLength = initialFrame.slice(0,4),
			lengthPedestrianRegion = new DataView(bufferPedestrianRegionLength).getInt32(0,true),
			startPedestrianRegionBuffer = 4,
			endPedestrianRegionBuffer = startPedestrianRegionBuffer + lengthPedestrianRegion*lengthPedestrianRegionObj*8,
			pedestriansRegionsBuffer = initialFrame.slice(startPedestrianRegionBuffer,endPedestrianRegionBuffer),
			pedestriansRegions = new Float64Array(pedestriansRegionsBuffer),

			indexStartPedestrian = endPedestrianRegionBuffer,
			bufferPedestrianLength = initialFrame.slice(indexStartPedestrian,indexStartPedestrian + 4),
			lengthPedestrian = new DataView(bufferPedestrianLength).getInt32(0,true),
			startPedestrianBuffer = indexStartPedestrian + 4,
			endPedestrianBuffer = startPedestrianBuffer + lengthPedestrian*lengthPedestrianObj*8,
			pedestriansBuffer = initialFrame.slice(startPedestrianBuffer,endPedestrianBuffer),
			pedestrians = new Float64Array(pedestriansBuffer),

			indexStartObstacle = endPedestrianBuffer,
			obstacleLengthBuffer = initialFrame.slice(indexStartObstacle,indexStartObstacle + 4),
			lengthObstacle = new DataView(obstacleLengthBuffer).getInt32(0,true),
			startObstacleBuffer = indexStartObstacle + 4,
			endObstacleBuffer = startObstacleBuffer + lengthObstacle*lengthObstacleObj*8,
			obstaclesBuffer = initialFrame.slice(startObstacleBuffer,endObstacleBuffer),
			obstacles = new Float64Array(obstaclesBuffer),

			indexStartWaypoint = endObstacleBuffer,
			waypointLengthBuffer = initialFrame.slice(indexStartWaypoint, indexStartWaypoint + 4),
			lengthWaypoint = new DataView(waypointLengthBuffer).getInt32(0,true),
			startWaypointBuffer = indexStartWaypoint + 4,
			endWaypointBuffer = startWaypointBuffer + lengthWaypoint*lengthWaypointObj*8,
			waypointsBuffer = initialFrame.slice(startWaypointBuffer,endWaypointBuffer),
			waypoints = new Float64Array(waypointsBuffer),

			indexStartObjective = endWaypointBuffer,
			objectiveLengthBuffer = initialFrame.slice(indexStartObjective, indexStartObjective + 4),
			lengthObjective = new DataView(objectiveLengthBuffer).getInt32(0,true),
			startObjectiveBuffer = indexStartObjective + 4,
			endObjectiveBuffer = startObjectiveBuffer + lengthObjective*lengthObjectiveObj*8,
			objectivesBuffer = initialFrame.slice(startObjectiveBuffer,endObjectiveBuffer),
			objectives = new Float64Array(objectivesBuffer);

			return [pedestriansRegions, pedestrians, obstacles, waypoints, objectives];

	},
	parseFrame: function (frame) {
		"use strict";
		var lengthPedestrian = frame.length / 4,
			index = 0,
			arr = [],
			start = 0;
		for(index = 0; index < lengthPedestrian; index++) {
			start = index*4;
			arr.push([frame[start],frame[start+1],frame[start+2],frame[start+3]]);
		}
		return arr;
	},
	parsePedestrians: function(pedestrianArr) {
		"use strict";
		var lengthPedestrian = pedestrianArr.length / 6,
			index = 0,
			start = 0,
			pedestrians = [];
		for(index = 0; index < lengthPedestrian; index++) {
			start = index*6;
			pedestrians.push([pedestrianArr[start],pedestrianArr[start+1],pedestrianArr[start+2],pedestrianArr[start+3],pedestrianArr[start+4],pedestrianArr[start+5]]);
		}
		return pedestrians;

	},
	parsePedestriansRegions:function(pedestrianRegionArr) {
		"use strict";
		var lengthPedestrianRegion = pedestrianRegionArr.length / 5,
			index = 0,
			start = 0,
			pedestriansRegions = [];
		for(index = 0; index < lengthPedestrianRegion; index++) {
			start = index*5;
			pedestriansRegions.push([pedestrianRegionArr[start],pedestrianRegionArr[start+1],pedestrianRegionArr[start+2],pedestrianRegionArr[start+3],pedestrianRegionArr[start+4]]);
		}
		return pedestriansRegions;
	},
	parseObstacles: function(obstaclesArr) {
		"use strict";
		var lengthObstacle = obstaclesArr.length / 4,
			index = 0,
			start = 0,
			obstacles = [];
		for(index = 0; index < lengthObstacle; index++) {
			start = index*4;
			obstacles.push([obstaclesArr[start],obstaclesArr[start+1],obstaclesArr[start+2],obstaclesArr[start+3]]);
		}
		return obstacles;
	},
	parseWaypoints: function(waypointArr) {
		"use strict";
		var lengthWaypoint = waypointArr.length / 3,
			index = 0,
			start = 0,
			waypoints = [];
		for(index = 0; index < lengthWaypoint; index++) {
			start = index*3;
			waypoints.push([waypointArr[start],waypointArr[start+1],waypointArr[start+2]]);
		}
		return waypoints;
	},
	parseObjectives : function(objectiveArr) {
		"use strict";
		var lengthObjective = objectiveArr.length / 3,
			index = 0,
			start = 0,
			objectives = [];
		for(index = 0; index < lengthObjective; index++) {
			start = index*3;
			objectives.push([objectiveArr[start],objectiveArr[start+1],objectiveArr[start+2]]);
		}
		return objectives;
	},
	parsePedestrianInformation: function(informationArr) {
    "use strict";
    var length = informationArr.length / 10,
        index = 0,
        start = 0,
        forces = [];
    ((informationArr.length % 10) > 0) && console.log(" incorrect array information size");
    for(index = 0; index < length; index++) {
      start = index*10;
      forces.push([{x:informationArr[start],y:informationArr[start+1]},//social force
                  {x:informationArr[start+2],y:informationArr[start+3]},//social granular
                  {x:informationArr[start+4],y:informationArr[start+5]},//obstacle
                  {x:informationArr[start+6],y:informationArr[start+7]},//obstacle granular
                  {x:informationArr[start+8],y:informationArr[start+9]}]);//desired
    }
    return forces;
	},
	updatePedestrian: function() {

	},
	parseMessage: function(data) {
		"use strict";
		//data = [headMessage, bodyData]
		//headMessage = [int32:LengthBytesNameAction, String:stringAction ]
		//bodyData = [Float32:IDFramePackge,Float32:LengthBytesFramePackageCompresse, FramePackageCompressed]
		//FramePackageUncompressed = [headFramePackage, bodyFramePackage]
		//headFramePackage = [[positionX,positionY,]]
		var bufferLength = data.slice(0,4),
		nLength = new DataView(bufferLength).getInt32(0,true),
		bufferAction = data.slice(4,4+nLength),
		actionName = this.stringDecoder.decode(new Uint8Array(bufferAction)),
		startData = 4+nLength,
		frameLength = 101,
		lengthByteFloat16 = 2,
		informationLength = 4,
		numberBuffer = null,
		arr = null,
		numberFrame = 0,
		lengthBytes = 0,
		frameStart = 0,
		frameBufferCompressed = null,
		framesBytes = null,
		framesBuffer = null,
		nPedestrians = 0,
		frameBuffer = null,
		headBuffer = null,
		head = null,
		startBody = 0,
		lengthFrame = 0,
		current = null,
		startCurrent = 0,
		endCurrent = 0,
		currentBuffer = null,
		float16Arr = null,
		framesArr = null,
		information = null,
    framesInformation = null,
    startIDInformation = 0,
		startInformation = 0,
		index = 0,
		index2 = 0,
    ids = null,
    idBlock = -1,
    idInformation = -1;
    console.log(actionName);
		function deepCopy(oldArr) {
			var index = 0,
			oldArrBuffer = new Uint8Array(oldArr.buffer),
			newArrBuffer = new Uint8Array(new ArrayBuffer(oldArr.buffer.byteLength)),
			iterations = newArrBuffer.length;
			for(index = 0; index < iterations; index++) {
				newArrBuffer[index] = oldArrBuffer[index];
			}
			return new Float32Array(newArrBuffer.buffer);
		}

		if (actionName === "getFrame") {
			numberBuffer = data.slice(startData,startData+4);
			arr = new Float32Array(numberBuffer);
			numberFrame = arr[0];
			//lengthBytes = arr[1];
			frameStart = startData+4;
			frameBufferCompressed  = data.slice(frameStart);
			framesBytes = pako.inflate(new Uint8Array(frameBufferCompressed));
			nPedestrians = framesBytes.length / (frameLength * lengthByteFloat16 * informationLength);
			framesBuffer = framesBytes.buffer;
			headBuffer = framesBuffer.slice(0,nPedestrians*lengthByteFloat16 * informationLength * 2);
			framesArr = new Array(100);
			head = new Float32Array(headBuffer);
			startBody = nPedestrians*lengthByteFloat16 * informationLength * 2;
			lengthFrame =  nPedestrians*lengthByteFloat16 * informationLength;


			framesArr[0] = head;
			current = deepCopy(head);
			for(index = 0; index < 99; index++) {

				startCurrent = startBody + (index * lengthFrame);
				endCurrent = startBody + ((index+1) * lengthFrame);
				currentBuffer = framesBuffer.slice(startCurrent,endCurrent);
				float16Arr = new Uint16Array(currentBuffer);

				for(index2 = 0; index2 < float16Arr.length; index2++) {
					current[index2] += float16ToFloat32(float16Arr[index2])
				}

				framesArr[index+1] = current;
				current = deepCopy(current);
			}

      return {
					id:numberFrame,
					data:framesArr,
					action:actionName
				};

		} else if (actionName === "getInformation") {
            startIDInformation = startData;
            startInformation = startIDInformation+8;
            ids = new Float32Array(data.slice(startIDInformation,startIDInformation+8));
            idBlock = ids[0];
            idInformation = ids[1];

            information = new Float64Array(data.slice(startInformation));
            framesInformation = this.parsePedestrianInformation(information);
            return {
                idBlock:idBlock,
                idInformation:idInformation,
                data:framesInformation,
                action:actionName
            };
		} else if(actionName === "open") {
			return {
                id:-1,
                hash:new Uint8Array(data.slice(startData,startData+64)),
                totalLength:new DataView(data.slice(startData+64,startData+68)).getInt32(0,true),
                data:data.slice(startData+68),
                action:actionName
            };
		} else if(actionName === "socialAnswer") {
            var dataViewSocial = new DataView(data.slice(startData)),
            counter = 0,
            obj = {
                DistancePeds: dataViewSocial.getFloat64(counter*8,(counter++)*8),
                angleVelocityPed1: dataViewSocial.getFloat64(counter*8,(counter++)*8),
                angleVelocityPed2:  dataViewSocial.getFloat64(counter*8,(counter++)*8),
                differenceAngle :  dataViewSocial.getFloat64(counter*8,(counter++)*8),
                totalVelPed1:  dataViewSocial.getFloat64(counter*8,(counter++)*8),
                totalVelPed2:  dataViewSocial.getFloat64(counter*8,(counter++)*8),
                relativeVelocity:{x: dataViewSocial.getFloat64(counter*8,(counter++)*8),y: dataViewSocial.getFloat64(counter*8,(counter++)*8)},
                totalRelVelPed:  dataViewSocial.getFloat64(counter*8,(counter++)*8),
                angleRelativeVelocity:  dataViewSocial.getFloat64(counter*8,(counter++)*8),
                E:{x: dataViewSocial.getFloat64(counter*8,(counter++)*8),y: dataViewSocial.getFloat64(counter*8,(counter++)*8)},
                angleE: dataViewSocial.getFloat64(counter*8,(counter++)*8),
                interactionVector:{x: dataViewSocial.getFloat64(counter*8,(counter++)*8),y: dataViewSocial.getFloat64(counter*8,(counter++)*8)},
                angleInteractionVector:dataViewSocial.getFloat64(counter*8,(counter++)*8),
                forceVelocity:{x: dataViewSocial.getFloat64(counter*8,(counter++)*8),y: dataViewSocial.getFloat64(counter*8,(counter++)*8)},
                forceAngle:{x: dataViewSocial.getFloat64(counter*8,(counter++)*8),y: dataViewSocial.getFloat64(counter*8,(counter++)*8)},
                relationForceAngle:dataViewSocial.getFloat64(counter*8,(counter++)*8),
                result:{x: dataViewSocial.getFloat64(counter*8,(counter++)*8),y: dataViewSocial.getFloat64(counter*8,(counter++)*8)},
                resultAngle:dataViewSocial.getFloat64(counter*8,(counter++)*8),
                thetaAngle:dataViewSocial.getFloat64(counter*8,(counter++)*8),
                percentilAngle:dataViewSocial.getFloat64(counter*8,(counter++)*8),
                differenceAngleT:dataViewSocial.getFloat64(counter*8,(counter++)*8)
            };
            return obj;
        }
	}

}
