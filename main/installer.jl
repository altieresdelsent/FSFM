 pkgs = ["Distances","Zlib","Debug","LibExpat","Morsel","Mustache","HttpServer","WebSockets","JSON"]
 for name in pkgs
 	Pkg.add(name)
 	Pkg.update()
 end