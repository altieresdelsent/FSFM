 pkgs = ["Distances","Zlib","Debug","LibExpat","Morsel","Mustache","HttpServer","WebSockets","JSON","Gadfly"]
 for name in pkgs
 	Pkg.add(name)
 	Pkg.update()
 end
