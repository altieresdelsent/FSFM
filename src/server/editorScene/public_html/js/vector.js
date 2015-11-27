Vector = {
	create: function(x,y) {
		return {"x":x,"y":y};
	},
	multiplyScalar: function(vec,scalar) {
		return Vector.create(vec.x * scalar,vec.y * scalar);
	},
	sumScalar: function() {
		return Vector.create(vec.x + scalar,vec.y + scalar);
	},
	sum: function(vec1,vec2)  {
		return Vector.create(vec1.x + vec2.x,vec1.y + vec2.y);
	},
	dotProduct: function(vec1,vec2) {
		return (vec1.x * vec2.x + vec1.y * vec2.y);
	}
}