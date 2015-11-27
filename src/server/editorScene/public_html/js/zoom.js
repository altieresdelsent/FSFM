function createZoom(canvas) {
	resolution = {};
	Object.defineProperty(resolution, "x", {
        get: function() {
        	return parseFloat(canvas.width); 
        },
    });

    Object.defineProperty(resolution, "y", {
        get: function() {
        	return parseFloat(canvas.height); 
        },
    });
	return {
		_canvas:canvas,
		_sumX:0,
		_sumY:0,
		_scale:1,
		growthIndex:1.01,
		resolution : resolution,
		realLength: function(length) {
			return length/this._scale;
		},
		realPosition: function(position) {
			var xReal = position.x - this.lengthInScreen(this._sumX) - (this.resolution.x * 0.5),
				yReal = (this.resolution.y * 0.5) - position.y - this.lengthInScreen(this._sumY);
			return {x:this.realLength(xReal),
				y:this.realLength(yReal)
			};
		},
		zoom: function(scaleChange) {
			if(arguments.length > 0) {
				if(scaleChange === true) {
					this._scale *= this.growthIndex;
				} else if(scaleChange === false) {
					this._scale *= (1/this.growthIndex);
				} else {
					this._scale = scaleChange;
				}
			} else {
				this._scale *= 1.1;
			}

		},
		moveX: function(sumXChange) {
			if(arguments.length > 0) {
				this._sumX += sumXChange/this._scale;
			} else {
				this._sumX += 1;
			}
		},
		moveY: function(sumYChange) {
			if(arguments.length > 0) {
				this._sumY +=  -sumYChange/this._scale;
			} else {
				this._sumY += 1;
			}
		},
		lengthInScreen: function(length) {
			return length*this._scale;
		},
		positionInScreen: function(realPosition) {
			var xInScreen = this.lengthInScreen(realPosition.x) + this.resolution.x * 0.5,
				yInScreen = (this.resolution.y * 0.5) - this.lengthInScreen(realPosition.y); 
			return {x:(xInScreen + this.lengthInScreen(this._sumX)),
				y:(yInScreen - this.lengthInScreen(this._sumY))
			};
		},
		centralize: function(xMax,yMax, xMin, yMin) {
			var scaleY = this.resolution.x / (xMax-xMin),
				scaleX = this.resolution.y / (yMax-yMin);

				this._scale = (scaleX < scaleY)? scaleX*0.98:scaleY*0.98;
				this._sumX = -xMin - (xMax-xMin) * 0.5;
				this._sumY = -yMin - (yMax-yMin) * 0.5;
		}
	};
}