package hx_webserver;

import sys.net.Socket;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Bytes;
import hx_webserver.HTTPServer;
import haxe.io.BytesOutput;

using StringTools;

class HTTPRequest {
    public var data:String = null;
    public var headers:Array<Array<String>> = [];
    public var error:String = null;
    public var client:Socket;
    public var postData:String = "";
    private var server:HTTPServer;
    public var methods:Array<String>;
    public var formdata:FormdataRequest;
    public var bytesOutput:BytesOutput;
    public var bytes:Bytes;
    /**
	 * POST Data
	 */
	public var postData:Bytes;

	/**
	 * HOST
	 */
	public var host:String;

	/**
	 * Content length
	 */
	public var contentLength:Int;

	/**
	 * Content type
	 */
	public var contentType:String;
    
    public function new (d:Socket, server:HTTPServer, head:String):Void {
        if (d == null) return;

        bytesOutput = new BytesOutput();
        try {
            this.client = d;
            this.server = server;

            client = d;
            handleBytes(d);
            var bytesb = bytesOutput;
            bytes = bytesb.getBytes();

            data = bytes.toString();
            //trace(data);

            var split = data.split("\n");
            var newlineReached:Bool = false;
            for (i in 0...split.length) {
                if (split[i] == "\r" || split[i] == "\n" || split[i] == "\r\n") {
                    newlineReached = true;
                }
                if (!newlineReached) {
                    var splitAgain:Array<String> = split[i].split(": ");
                    this.headers.push([splitAgain[0], splitAgain[1]]);
                }
            }

            methods = head.split(" ");
            if (methods[0] != "GET") { //hold on this isn't a get request?
                var t:Array<String> = this.data.split("\r\n");
                var v:Int = 0;
                for (i in 0...t.length) {
                    if (t[i] == " " || t[i] == "" || t[i] == "\r" || t[i] == "\n") {
                        v = i;
                    }
                }
                var f:String = "";
                for (i in 0...v) {
                    f += t[i] + "\r\n";
                }
                postData = this.data.split(f)[1];
                postData = postData.replace("\r", "");
            }

            if (getHeaderValue("Content-Type").contains("multipart/form-data;")) {
                formdata = new FormdataRequest(this);
            }
        } catch (err:String) {
            this.error = err;
        }
    }
    private function handleBytes(socket:Socket) {
        var input = socket.input;
		while (true) {
			var content = input.readLine();
			if (content == "") {
				break;
			}
			var datas = content.split(" ");
			switch datas[0] {
				case "host:":
					host = datas[1];
				case "Content-Length:":
					contentLength = Std.parseInt(datas[1]);
				case "Content-Type:":
					contentType = datas[1];
			}
		}
		if (contentLength > 0) {
			postData = Bytes.alloc(contentLength);
			input.readBytes(postData, 0, contentLength);
		}
    }
    public function getHeaderValue(header:String):String {
        var tlcheader:String = header.toLowerCase();
        var headerValue:String = null;
        for (i in 0...headers.length) {
            for (x in 0...headers[i].length) {
                if (headers[i][0].toLowerCase() == tlcheader) {
                    headerValue = headers[i][1];
                }
            }
        }
        return headerValue;
    }
    public function close():Void {
        client.close();
    }
    public function replyData(text:String, mime:String, ?code:Int = 200):Void {
        @:privateAccess
        var response:Bytes = server.prepareHttpResponse(code, mime, haxe.io.Bytes.ofString(text));
        client.output.writeFullBytes(response, 0, response.length);
    }
    public function reply(text:String, ?code:Int = 200):Void {
        @:privateAccess
        var response:Bytes = server.prepareHttpResponse(code, "text/plain", haxe.io.Bytes.ofString(text));
        client.output.writeFullBytes(response, 0, response.length);
    }
    public function replyWithFile(file:String, ?code:Int = 200):Void {
        if (!FileSystem.exists(file)) {
            //do nothing :(
        } else {
            var bytes:Bytes = sys.io.File.getBytes(file);
            var mime:String = HTTPUtils.getMimeType(file);
            @:privateAccess
            /*var response:Bytes = server.prepareHttpResponse(code, mime, bytes);
            client.output.writeFullBytes(response, 0, response.length);*/
            /*
                This is EXTREMELY unefficient, considering that sending a direct chunk of all bytes could be kinda painful for the server.
                Best way is to send 1024 chunks of bytes constantly, until it's over
            */
            sys.thread.Thread.create(() -> {
                // We cannot use prepareHttpResponse, we need to handle it ourselves
                var BO:BytesOutput = new BytesOutput();
                BO.writeString("HTTP/1.1 " + code + " " + HTTPUtils.codeToMessage(code));
                BO.writeString("\r\n");
                BO.writeString("Content-Length: " + bytes.length);
                BO.writeString("\r\n");
                BO.writeString("Content-Type: " + mime);
                BO.writeString("\r\n");
                BO.writeString("Access-Control-Allow-Origin: *"); // js fetch is strict with CORS
                BO.writeString("\r\n");
                BO.writeString("\r\n");
                var actualBytes:Bytes = BO.getBytes();
                trace("RESPONSE SENT");
                client.output.writeFullBytes(actualBytes, 0, actualBytes.length);
                
                // Response sent, we need to send the bytes now.
                var chunkOver:Bool = false;
                while (!chunkOver) {
                    var chunkSize = Math.min(bytes.length, 1024);
                    var currentChunk:Bytes = bytes.sub(0, Std.int(chunkSize));
                    var errored:Bool = false;
                    
                    //trace("SENDING CHUNKS "+chunkSize+" BYTES: BYTES LENGTH IS " + bytes.length + "!!!");
                    try {
                        client.output.writeFullBytes(currentChunk, 0, Std.int(chunkSize));
                    } catch (e:Dynamic) {
                        //trace("ERROR!");
                        errored = true;
                        client.close();
                        chunkOver = true;
                    }
            
                    // Reduce the remaining bytes
                    bytes = bytes.sub(Std.int(chunkSize), Std.int(bytes.length - chunkSize));
                    
                    // Check if we have sent all data
                    if (bytes.length == 0) {
                        chunkOver = true;
                    }
                }
            });            
        }
    }

    public function replyRaw(bytes: haxe.io.Bytes) {
        client.output.writeFullBytes(bytes, 0, bytes.length);
    }
}
