package hx_webserver;

import sys.net.Socket;
import sys.net.Host;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import hx_webserver.HTTPRequest;
import hx_webserver.HTTPUtils;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class HTTPServer {
    private var ip:String = null;
    private var port:Int = 0;
    private var log:Bool = false;
    public var server:sys.net.Socket;
    private var on:Bool = true;
    public function new(ip:String, port:Int, ?log:Bool) {
        this.ip = ip;
        this.port = port;
        if (log == null) {
            this.log = false;
        } else {
            this.log = log;
        }
        on = true;
        haxe.EntryPoint.addThread(start);
    }
    dynamic public function onClientConnect(d:HTTPRequest) { }
    private function start() {
        server = new Socket();
        try {
            server.bind(new Host(ip), port);
        } catch (err:String) {
            throw "Cannot bind to " + ip + ":" + port + ", perhaps the port is already being used?\n" + err;
        }
        server.listen(256);
        if (log) {
            trace("HTTP server successfully initialized at " + ip + ":" + port);
        }

        while (on) {
            try {
                var client:Socket = server.accept();
                var head:String = client.input.readLine();
                //trace(head);
                if (head.contains("HTTP/1.1")) {
                    sys.thread.Thread.create(() -> {
                        var req:HTTPRequest = new HTTPRequest(client, this, head);
                        onClientConnect(req);
                        if (log) {
                            trace("A new connection has been detected");
                        }
                    });
                }
            } catch (err) {
                if (this.log) {
                    trace("An error has occurred: " + err);
                }
            }
        }
    }
    private function prepareHttpResponse(code:Int, mime:String, value:Bytes):Bytes {
        var bytesOutput:BytesOutput = new BytesOutput();
        bytesOutput.writeString("HTTP/1.1 " + code + " " + HTTPUtils.codeToMessage(code));
        bytesOutput.writeString("\n");
        bytesOutput.writeString("Content-Length: " + value.length);
        bytesOutput.writeString("\n");
        bytesOutput.writeString("Content-Type: " + mime);
        bytesOutput.writeString("\n");
        bytesOutput.writeString("\n");
        bytesOutput.writeString(value.toString());
        bytesOutput.writeString("\r\n");
        //trace(bytes.toString());

        return bytesOutput.getBytes();
    }
}
