package hx_webserver;

import sys.net.Socket;
import sys.net.Host;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import hx_webserver.HTTPRequest;

using StringTools;

class FormdataRequest {
    var boundary:String = "";
    var object:String = "";
    public function new(server:HTTPRequest) {
        boundary = server.getHeaderValue("Content-Type").split("multipart/form-data; boundary=")[1].replace("\r","");
        //funnies
        var bytesLength:Int = server.data.split("\r\n\r\n")[0].length;
        var serverBytes:Bytes = server.bytes;
        var actualBytes:Bytes = server.bytes.sub(bytesLength, serverBytes.length-bytesLength);
        
        //another funnies
        actualBytes = actualBytes.sub(4, actualBytes.length-132);
        object = actualBytes.toString().split("\n")[1].split("Content-Disposition: form-data;")[1].split("name=")[1].split(";")[0].replace("\"","");
        trace(object);
    }
}