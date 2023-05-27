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
    public var bytesOutput:BytesOutput;
    public function new (d:Socket, server:HTTPServer, head:String):Void {
        if (d == null) return;

        bytesOutput = new BytesOutput();
        try {
            this.client = d;
            this.server = server;

            client = d;
            handleBytes(d);
            data = bytesOutput.getBytes().toString();

            var split = data.split("\n");
            for (i in 0...split.length) {
                var splitAgain:Array<String> = split[i].split(": ");
                this.headers.push([splitAgain[0], splitAgain[1]]);
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
        } catch (err:String) {
            this.error = err;
        }
    }
    private function handleBytes(socket:Socket) {
        var input = socket.input;
        var bytes:Bytes = Bytes.alloc(1024);
        var read:Int = 0;
        var failed:Bool = false;
        try {
            read = input.readBytes(bytes,0,bytes.length);
        } catch (err:String) {
            failed = true;
        }
        if (!failed) {
            if (read == 1024) {
                //woah there might be more bytes
                bytesOutput.writeBytes(bytes, 0, read);
                handleBytes(socket);
            } else if (read < 1024 && read != 0) {
                //last straw i think
                bytesOutput.writeBytes(bytes, 0, read);
            } else if (read == 0) {
                //do nothing
            }
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
            var response:Bytes = server.prepareHttpResponse(code, mime, bytes);
            client.output.writeFullBytes(response, 0, response.length);
        }
    }

    public function replyRaw(bytes: haxe.io.Bytes) {
        client.output.writeFullBytes(bytes, 0, bytes.length);
    }
}
