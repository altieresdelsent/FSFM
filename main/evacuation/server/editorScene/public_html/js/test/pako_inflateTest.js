"use strict";
function carregar() {
	var loader = new WebSocket("ws://localhost:8888");
	loader.onopen = function() {
		loader.send(JSON.stringify({action:"pakoTest"}));
	};
	loader.onerror = function(evt) {
		console.log("The following error occurred: " + evt.data);
	};
	loader.onmessage = function(msg) {
		var fileReader = new FileReader();
		fileReader.onload = function () {
			var bufferCompressed = new Uint8Array(this.result),
			indice = 0,
			str = "",
			//bufferUncompressed = pako.inflate(bufferCompressed),
			//arr = new Float32Array(datas.buffer);
			arr = new Float32Array(new ArrayBuffer(4000)),
			compressed = null,
			bufferFinal = null;
			for(indice = 0; indice < arr.length; indice++) {
				arr[indice] = (indice+1) / 10;
			}
			compressed = pako.deflate(new Uint8Array(arr.buffer));
			bufferFinal = new Float32Array(pako.inflate(bufferCompressed).buffer);

			for(indice = 0; indice < compressed.length; indice++) {
				if (compressed[indice] != bufferCompressed[indice]) {
					str += "indice = "+indice+" com valor "+bufferCompressed[indice]+" deveria ser"+compressed[indice]+"  ,    ";
				}
			}
			for(indice = 0; indice < bufferFinal.length; indice++) {
				str += "indice = "+indice+" com valor "+bufferFinal[indice]+"  ,    ";
			}
			document.getElementById("text").textContent = str;
			loader.close();
		};
		fileReader.readAsArrayBuffer(msg.data);
	};
}