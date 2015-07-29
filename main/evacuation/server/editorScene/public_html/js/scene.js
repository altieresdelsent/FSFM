/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//alert([Number.MAX_VALUE, Number.MIN_VALUE]);
//alert(2^32);
//alert(Math.pow(2,32));
//alert(Math.log(Number.MAX_VALUE));

function Scene(name, pedestrians, obstacles, waypoints, objectives) {
    "use strict";
    this.name = name;
    
    this.pedestrianRegions = [];
    this.obstacles = [];
    this.waypoints = [];
    this.objectives = [];

    this.clear = __clear;
    this.addPedestrian = __addPedestrian;
    this.addObstacle = __addObstacle;
    this.addWaypoint = __addWaypoint;
    this.addObjective = __addObjective;

    var here = this;
    function __clear() {
        this.pedestrianRegions = [];
        this.obstacles = [];
        this.wayPoints = [];
        this.objectives = [];        
    }

    function __addPedestrian(position,lengthX, lengthY, n) {
        var pedestrian = new __PedestrianRegion(position,lengthX, lengthY, n);
        this.pedestrianRegions.push(pedestrian);
    }

    function __addObstacle(start, ender) {
        var obstacle = new __Obstacle(start, ender);
        this.obstacles.push(obstacle);
    }

    function __addWaypoint(position,radius) {
        var waypoint = new __Waypoint(position,radius);
        this.waypoints.push(waypoint);
    }

    function __addObjective(position,radius) {
        var objective = new __Objective(position,radius);
        this.objectives.push(objective);
    }
    
    function __createPedestriansRegion(pedestrians) {
        var pedValue = null,
            indice = 0;
        for(indice = 0; indice < pedestrians.length; indice++) {
            pedValue = pedestrians[indice];
            __addPedestrian.call(here,{x:pedValue[0],y:pedValue[1]},pedValue[2],pedValue[3],pedValue[4]);
        }
    }

    function __createObstacles(obstacles) {
        var obstacleValue = null,
            indice = 0;
        for(indice = 0; indice < obstacles.length; indice++) {
            obstacleValue = obstacles[indice];
            __addObstacle.call(here,{x:obstacleValue[0],y:obstacleValue[1]},{x:obstacleValue[2],y:obstacleValue[3]});
        }

    }

    function __createWaypoints(waypoints) {
        var waypointValue = null,
            indice = 0;
        for(indice = 0; indice < waypoints.length; indice++) {
            waypointValue = waypoints[indice];
            __addWaypoint.call(here,{x:waypointValue[0],y:waypointValue[1]},waypointValue[2]);
        }
    }

    function __createObjectives(objectives) {
        var objectiveValue = null,
            indice = 0;
        for(indice = 0; indice < objectives.length; indice++) {
            objectiveValue = objectives[indice];
            __addObjective.call(here,{x:objectiveValue[0],y:objectiveValue[1]},objectiveValue[2]);
        }
    }

    //Define PedestrianRegion class
    //#########################################################
    function __PedestrianRegion(position,width,height,number) {
        if((arguments.length >= 1)&&(isDefined(position))) {
            this.position = position;
        } else {
            this.position = [0.0, 0.0];
        }
        
        if((arguments.length >= 2)&&(isDefined(width))) {
            this.width = parseFloat(width);
        } else {
            this.width = 1;
        }
        
        if((arguments.length >= 3)&&(isDefined(height))) {
            this.height = parseFloat(height);
        } else {
            this.height = 3;
        }
        
        if((arguments.length >= 4)&&(isDefined(number))) {
            this.n = parseFloat(number);
        } else {
            this.n = 1;
        }
    }
    //********************************************************
    
    
    //Define Obstacle class
    //#####################################################
    function __Obstacle(start,ender) {
        
        if((arguments.length >= 1)&&(isDefined(start))) {
            this.start = start;
        } else {
            this.start = [0.0, 0.0];
        }
        
        if((arguments.length >= 2)&&(isDefined(ender))) {
            this.ender = ender;
        } else {
            this.ender = [0.0, 0.0];
        }
    }
    //****************************************************
    
    //Define WayPoint class
    //####################################################
    function __Waypoint(position,radius) {
        if((arguments.length >= 1)&&(isDefined(position))) {
            this.position = position;
        } else {
            this.position = [0.0, 0.0];
        }
        if((arguments.length >= 2)&&(isDefined(radius))) {
            this.radius = parseFloat(radius);
        } else {
            this.radius = 0;
        }        
    }
    //****************************************************
    
    //Define Objective class
    //####################################################
    function __Objective(position,radius) {
        if((arguments.length >= 1)&&(isDefined(position))) {
            this.position = position;
        } else {
            this.position = [0.0, 0.0];
        }
        if((arguments.length >= 2)&&(isDefined(radius))) {
            this.radius = parseFloat(radius);
        } else {
            this.radius = 0;
        }
    }
    //****************************************************    
    
    
    
    
    // Util functions
    

    // Changes XML to JSON
    

    __createPedestriansRegion(pedestrians);
    __createObstacles(obstacles);
    __createWaypoints(waypoints);
    __createObjectives(objectives);
}

function round4(str) {
    var valor = parseFloat(str);
    valor *= 10000;
    valor = Math.round(valor);
    valor /= 10000;
    return valor;
}
function isDefined(val) {
    return ((typeof(val) !== "undefined")&&(val !== null));
}
function numbersNotEqual(val1,val2) {
    var precision =  Math.pow(2,32);
    if ((!isDefined(val1))||(!isDefined(val2))) {
        return true;
    }
    return (Math.round(val1*precision) !== Math.round(val2*precision));
}
    //####################################################
    
    
    