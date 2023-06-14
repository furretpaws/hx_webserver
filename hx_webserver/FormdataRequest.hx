package hx_webserver;

import sys.net.Socket;
import sys.net.Host;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import hx_webserver.HTTPRequest;

using StringTools;

class FormdataRequest {
    public var boundary:String = "";
    public var object:String = "";
    public var filename:Dynamic = "";
    public var bytes:Bytes = null;
    //no mimetype since idk why would you need that
    public function new(server:HTTPRequest) {
        boundary = server.getHeaderValue("Content-Type").split("multipart/form-data; boundary=")[1].replace("\r","");
        //funnies
        var bytesLength:Int = server.data.split("\r\n\r\n")[0].length;
        var serverBytes:Bytes = server.bytes;
        var actualBytes:Bytes = server.bytes.sub(bytesLength, serverBytes.length-bytesLength);
        
        //another funnies
        actualBytes = actualBytes.sub(4, actualBytes.length-4);
        //trace(actualBytes.toString());
        object = actualBytes.toString().split("\n")[1].split("Content-Disposition: form-data;")[1].split("name=")[1].split(";")[0].replace("\"","");
        //trace(object);
        filename = actualBytes.toString().split("\n")[1].split("Content-Disposition: form-data;")[1].split("name=\""+object+"\";")[1].replace(" ", "").split("filename=\"")[1].split("\"")[0];
        var tempheaderSubStr = new StringBuf();
        tempheaderSubStr.add("--"+boundary+"\r\n");
        tempheaderSubStr.add(actualBytes.toString().split("\n")[1]+"\r\n");
        tempheaderSubStr.add(actualBytes.toString().split("\n")[2]+"\r\n");
        actualBytes = actualBytes.sub(tempheaderSubStr.toString().length, actualBytes.length-tempheaderSubStr.toString().length);
        actualBytes = actualBytes.sub(0, actualBytes.length-("--"+boundary+"--").length-2);
        bytes = actualBytes;
    }
    public function save(?filename:String = this.filename) {
        sys.io.File.saveBytes(filename, bytes);
    }
}