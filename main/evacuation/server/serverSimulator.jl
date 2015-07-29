include("path.jl")
using Morsel
using Mustache

app = Morsel.app()
const siteBasePath = "$pathBaseFSFM/evacuation/server/editorScene/public_html"
cd(siteBasePath)

route(app, GET, "/") do req, res
#print("7")
	#return "testeee"
	fileReader = open("index.html")
	lines = utf8(readbytes(fileReader))
	close(fileReader)
    return lines
end

route(app, GET, "/social") do req, res
#print("7")
	#return "testeee"
	fileReader = open("visualizeSocial.html")
	lines = utf8(readbytes(fileReader))
	close(fileReader)
    return lines
end

route(app, GET, "/teste") do req, res
#print("7")
	#return "testeee"
	fileReader = open("testWebSocket.html")
	lines = utf8(readbytes(fileReader))
	close(fileReader)
    return lines
end

route(app, GET, "/video/<videoName>") do req, res
#return string(req.params)
#print("6")
	#return "testeee"
	videoName = req.params[:videoName]
	fileReader = open("video.sm")
    lines = utf8(readbytes(fileReader))
    lines = render(lines,{"videoName" => videoName})
    res.headers["Content-Type"]  = "text/html; charset=utf-8"

	close(fileReader)
    return lines
end


route(app, GET, "/test/<htmlfile>") do req, res
	#return "testeee"
	#print("3")
	htmlfile = req.params[:htmlfile]
	#nameFile = req.state[:route_params]["nameFolder"]
	fileReader = open("test/$htmlfile.html")
    lines = utf8(readbytes(fileReader))
    res.headers["Content-Type"]  = "text/html; charset=utf-8"

	close(fileReader)
    return lines
end

route(app, GET, "/js/<javascriptfile>") do req, res
#print("4")
	#return string(req.state[:route_params])
	javascriptfile = req.params[:javascriptfile]
	#print(string(req))
	fileReader = open("js/$javascriptfile.js")
    lines = utf8(readbytes(fileReader))
    res.headers["Content-Type"]  = "application/javascript; charset=utf-8"

	close(fileReader)
    return lines
end

route(app, GET, "/css/<cssfile>") do req, res
#print("5")
#return string(res)
	cssfile = req.params[:cssfile]
	fileReader = open("css/$cssfile.css")
    lines = utf8(readbytes(fileReader))
    res.headers["Content-Type"]  = "text/css; charset=utf-8"

	close(fileReader)
    return lines
end


route(app, GET, "/js/test/<javascriptfile>") do req, res
	#return string(req.state[:route_params])
	#print("1")
	javascriptfile = req.params[:javascriptfile]
	fileReader = open("js/test/$javascriptfile.js")
    lines = utf8(readbytes(fileReader))
    res.headers["Content-Type"]  = "application/javascript; charset=utf-8"

	close(fileReader)
    return lines
end

route(app, GET, "/img/svg/<svgfile>") do req, res
#return string(res)
#print("2")
	svgfile = req.params[:svgfile]
	fileReader = open("img/svg/$svgfile.svg")
    lines = utf8(readbytes(fileReader))
    res.headers["Content-Type"]  = "image/svg+xml; charset=utf-8"

	close(fileReader)
    return lines
end

route(app, GET, "/img/gif/<giffile>") do req, res
#return string(res)
#print("2")
	giffile = req.params[:giffile]
	fileReader = open("img/gif/$giffile.gif")
    lines = utf8(readbytes(fileReader))
    res.headers["Content-Type"]  = "image/gif;"

	close(fileReader)
    return lines
end

route(app, GET, "/<test1>/<test>") do req, res
	return string(req)
end







start(app, 8080)
