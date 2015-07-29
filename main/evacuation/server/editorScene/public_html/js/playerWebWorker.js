importScripts("pako")
importScripts("float16ToFloat32")
importScripts("binaryParser")
hasFileReader = self.hasOwnProperty("FileReader")
hasFileReaderSync = self.hasOwnProperty("FileReaderSync")
onmessage = function(msg) {
	// postMessage("FileReaderSync"+hasFileReaderSync)
	// postMessage( "FileReader"+hasFileReader)
	if(hasFileReaderSync) {
		var blobReader = new FileReaderSync();
		var parsedMessage = BinaryParser.parseMessage(blobReader.readAsArrayBuffer(msg.data));
	    postMessage(parsedMessage);
	} else if(hasFileReader) {
		var blobReader = new FileReader();
	    blobReader.onload = function() {
	        var parsedMessage = BinaryParser.parseMessage(this.result);
	        postMessage(parsedMessage);
	    };
	    blobReader.readAsArrayBuffer(msg.data);
	}

}
