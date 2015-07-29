/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Simulation(videoName, pedestrians) {
    "use strict";
    var indice = 0,
    ped = null;
    this.pedestrians = [];
    this.name = videoName;
    this.forces = {
      social:{x:0,y:0},
      socialGranular:{x:0,y:0},
      obstacle:{x:0,y:0},
      obstacleGranular:{x:0,y:0},
      desired:{x:0,y:0}};

    this.addPedestrian = function(id,position,velocity,maxVelocity) {
    	var pedestrian = new __Pedestrian(id,position,velocity,maxVelocity);
    	this.pedestrians.push(pedestrian);
    };

    this.addPedestrians = function(pedestrians) {
        var indice = 0,
            ped = null,
            id = 0,
            position = null,
            velocity = null,
            maxVelocity = 0;

        for(indice = 0; indice < pedestrians.length; indice++) {
            ped = pedestrians[indice];
            id = ped[0];
            position = {x:ped[1],y:ped[2]};
            velocity = {x:ped[3],y:ped[4]};
            maxVelocity = ped[5]
            this.addPedestrian(id,position,velocity,maxVelocity);
        }
    };

    this.updatePedestrians = function (pedestriansArr) {
        var indice = 0,
            ped = null,
            pedestrian = null;
        for(indice = 0; indice < pedestriansArr.length; indice++) {
            pedestrian = this.pedestrians[indice]
            ped = pedestriansArr[indice];
            pedestrian.position.x = ped[0];
            pedestrian.position.y = ped[1];
            pedestrian.velocity.x = ped[2];
            pedestrian.velocity.y = ped[3];
        }
    }

    this.updateForces = function(forces) {
        this.forces.social = forces[0];
        this.forces.social.color = randomColor();

        this.forces.socialGranular = forces[1];
        this.forces.socialGranular.color = randomColor();

        this.forces.obstacle = forces[2];
        this.forces.obstacle.color = randomColor();

        this.forces.obstacleGranular = forces[3];
        this.forces.obstacleGranular.color = randomColor();

        this.forces.desired = forces[4];
        this.forces.desired.color = randomColor();
    };

    this.findPedestrianByPosition = function(position) {
        var pedIni = this.pedestrians[0];
        return this.pedestrians.reduce(function(nearestPed,current) {
            var minDistance = realDistance(distanceVector(nearestPed.position,position)),
            distance = realDistance(distanceVector(current.position,position));

            if(minDistance > distance) {
                minDistance = distance;
                nearestPed = current;
            }
            return nearestPed;
        },pedIni);
    }
    function distanceVector(position1,position2) {
        return {x:position1.x - position2.x,
                y:position1.y - position2.y};
    }
    function realDistance(distanceVector) {
        return (distanceVector.x*distanceVector.x + distanceVector.y*distanceVector.y);
    }

    function randomColor() {
        return '#'+Math.floor(Math.random()*16777215).toString(16);
    }

    function __Pedestrian (id,position,velocity,maxVelocity) {
		this.id = id;
	    this.position = position;
	    this.velocity = velocity;
	    this.radius = 0.2;
      this.color = randomColor();
	    this.maxVelocity = maxVelocity;
	};

    this.addPedestrians(pedestrians);


}

