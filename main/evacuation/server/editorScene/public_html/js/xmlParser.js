XmlParser = {
	stringtoXML: function (text){
		var doc = null;
        if (window.ActiveXObject){
          doc = new ActiveXObject('Microsoft.XMLDOM');
          doc.async='false';
          doc.loadXML(text);
        } else {
          var parser = new DOMParser();
          var doc = parser.parseFromString(text,'text/xml');
        }
        return doc;
    },
	loadFromXML : function(xml) {
		if (typeof(xml) === "string") {
			xml = this.stringtoXML(xml);
		}
		var pedestrians = this.loadPedestriansRegion(xml.getElementsByTagName("agent")),
			obstacles = this.loadObstacles(xml.getElementsByTagName("obstacle")),
			waypoints = this.loadWaypoints(xml.getElementsByTagName("waypoint")),
			objectives = this.loadObjectives(xml.getElementsByTagName("objective"));

	},
	loadPedestriansRegion : function(pedestriansXmlArr) {
		var indice = 0,
			pedestrians = [],
			pedXml = null
			x = 0,
			y = 0,
			dx = 0,
			dy = 0,
			n = 0;
		for(indice = 0; indice < pedestriansXmlArr.length; indice++) {
			pedXml = pedestriansXmlArr[indice];
			x = parseFloat(pedXml.getAttribute("x"));
			y = parseFloat(pedXml.getAttribute("y"));
			dx = parseFloat(pedXml.getAttribute("dx"));
			dy = parseFloat(pedXml.getAttribute("dy"));
			n = parseFloat(pedXml.getAttribute("n"));
			pedestrians.push([[x,y],dx,dy,n]);
		}
		return pedestrians; 
	},
	loadObstacles: function(obstaclesXmlArr) {
		var indice = 0,
			obstacles = [],
			obstacleXml = null,
			x1 = 0,
			x2 = 0,
			y1 = 0,
			y2 = 0;
		for(indice = 0; indice < obstaclesXmlArr.length; indice++) {
			obstacleXml = obstaclesXmlArr[indice];

			x1 = parseFloat(obstacleXml.getAttribute("x1"));
			x2 = parseFloat(obstacleXml.getAttribute("x2"));
			y1 = parseFloat(obstacleXml.getAttribute("y1"));
			y2 = parseFloat(obstacleXml.getAttribute("y2"));

			obstacles.push([[x1,y1],[x2,y2]]);		
		}
		return obstacles;
	},
	loadWaypoints: function(waypointsXmlArr) {
		var indice = 0,
			waypoints = [],
			waypointXml = null,
			x= 0,
			y = 0,
			r = 0;
		for(indice = 0; indice < waypointsXmlArr.length; indice++) {
			waypointXml = waypointsXmlArr[indice];

			x = parseFloat(waypointXml.getAttribute("x"));
			y = parseFloat(waypointXml.getAttribute("y"));
			r = parseFloat(waypointXml.getAttribute("r"));

			waypoints.push([[x,y],r]);
		}
		return waypoints
	},
	loadObjectives: function(objectivesXmlArr) {
		var indice = 0,
			objectives = [],
			objectiveXml = null,
			x= 0,
			y = 0,
			r = 0;
		for(indice = 0; indice < objectivesXmlArr.length; indice++) {
			objectiveXml = objectivesXmlArr[indice];

			x = parseFloat(objectiveXml.getAttribute("x"));
			y = parseFloat(objectiveXml.getAttribute("y"));
			r = parseFloat(objectiveXml.getAttribute("r"));

			objectives.push([[x,y],r]);
		}
		return objectives
	},
	writeXML: function(scene){
		xmlExport = stringtoXML("<welcome></welcome>");
		this.writePedestrianRegion(scene, xmlExport);
		this.writeObstacle(scene, xmlExport);
		this.writeWaypoint(scene, xmlExport);
		this.writeObjective(scene, xmlExport);
	},
	writePedestrianRegion: function(scene, xmlExport) {
		var agent = null,
		ped = null;
		for(indice = 0; indice < scene.pedestrians.length; indice++) {
			agent = xmlExport.createElement("agent");
			ped = scene.pedestrians[indice];
			agent.setAttribute("x",ped.position[0]);
			agent.setAttribute("y",ped.position[1]);
			agent.setAttribute("dx",ped.xLength);
			agent.setAttribute("dy",ped.yLength);
			agent.setAttribute("n",ped.n);
			xmlExport.appendChild(agent);
		}
	},
	writeObstacle: function(scene, xmlExport) {
		var obstacle = null,
		obst = null;
		for(indice = 0; indice < scene.obstacles.length; indice++) {
			obstacle = xmlExport.createElement("obstacle");
			obst = scene.obstacles[indice];
			obstacle.setAttribute("x1",obst.start[0]);
			obstacle.setAttribute("y1",obst.start[1]);
			obstacle.setAttribute("x2",obst.ender[0]);
			obstacle.setAttribute("y2",obst.ender[1]);
			xmlExport.appendChild(obstacle);
		}

	},
	writeWaypoint:function(scene, xmlExport) {
		var waypoint = null,
		way = null;
		for(indice = 0; indice < scene.waypoints.length; indice++) {
			waypoint = xmlExport.createElement("waypoint");
			way = scene.waypoints[indice];
			waypoint.setAttribute("x",way.position[0]);
			waypoint.setAttribute("y",way.position[1]);
			waypoint.setAttribute("r",way.r);
			xmlExport.appendChild(waypoint);
		}
	},
	writeObjective:function(scene, xmlExport) {
		var objective = null,
		obj = null;
		for(indice = 0; indice < scene.objectives.length; indice++) {
			objective = xmlExport.createElement("objective");
			obj = scene.objectives[indice];
			objective.setAttribute("x",obj.position[0]);
			objective.setAttribute("y",obj.position[1]);
			objective.setAttribute("r",obj.r);
			xmlExport.appendChild(objective);
		}
	}
}