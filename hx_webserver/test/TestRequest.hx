package hx_webserver.test;

import hx_webserver.HTTPRequest;

class TestRequest extends HTTPRequest {

    public function new(
        method: String,
        path: String,
        version: String = "HTTP/1.1"
    ) {
        super(null, null, null);
        this.methods = [method, path, version];
    }

    override function replyRaw(bytes: haxe.io.Bytes) {
        trace("\n" + bytes.toString());
    }

}
