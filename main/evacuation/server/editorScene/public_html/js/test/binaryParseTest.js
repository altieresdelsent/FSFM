function binaryParseMessageTest() {
	var binaryLoader = new WebSocket("ws://localhost:8888"),
	frames = null;
	binaryLoader.onopen = function () {
		//exampleSocket.send("getFrame");
		binaryLoader.send(JSON.stringify({action:"getFrame",number:1}));
	}
	//binaryLoader.onerror = function (evt) {
		//exampleSocket.send("getFrame");
	//	alert(evt.data)
	//}
	binaryLoader.onmessage = function (msg) {
		var blobReader = new FileReader();
		blobReader.onload = function() {
			var parsedMessage = BinaryParser.parseMessage(this.result)

			if (parsedMessage.action == "getFrame") {
				if (parsedMessage.frames.length == 100) {
					if(parsedMessage.id == 1) {
						frames = parsedMessage.frames;
						if (((frames[0][0] == 1)&&(frames[0][1] == 2)&&(frames[0][2] == 3)&&(frames[0][3] == 4))
							&&((frames[1][0] == 1.22998046875)&&(frames[1][1] == 2.344970703125)&&(frames[1][2] == 3.4560546875)&&(frames[1][3] == 4.56689453125))) {
							console.log("Tudo certo.");
						} else {
							console.log("Valores dos frames incorretos."+ frames.join());
						}
					} else {
						console.log("Id errado.");
					}
				} else {
					console.log("length dos frames errado.");
				}
			} else {
				console.log("Não foi possivel processar o nome da acao");
			}
		}
		blobReader.readAsArrayBuffer(msg.data);
		binaryLoader.close();
	}
	
	
}