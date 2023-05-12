package hx_webserver.test;

import sys.net.Socket;
import sys.net.Host;
import haxe.io.Bytes;
import haxe.io.Error;

import hx_webserver.HTTPResponse;
import hx_webserver.HTTPServer;
import hx_webserver.RouteMap;


class Main {

    static var server: Socket;

    static function main() {
        Main.serverTest();
    }

    static function serverTest() {
        var server = new HTTPServer("0.0.0.0", 8080, true);
        var routemap = new RouteMap();
        routemap.add("/hello", function (r) {
            return new HTTPResponse(Ok, "world");
        });
        routemap.attach(server);
    }

    static function routeTest() {
        var routemap = new RouteMap();
        routemap.add("/test", function (r) {
            return new HTTPResponse(Ok, "Test");
        });
        routemap.add("/error", function (r) {
            throw "error";
        });

        @:privateAccess routemap.routeRequest(new TestRequest("GET", "/test"));
        @:privateAccess routemap.routeRequest(new TestRequest("GET", "/error"));
        @:privateAccess routemap.routeRequest(new TestRequest("GET", "/404"));

    }

    static function responseTest() {
        var response = new HTTPResponse();
        response.content = "Hello, World";
        response.addHeader("Authorization", "password");
        var bytes = response.prepare();
        trace("\n" + bytes.toString());
    }

    static function socketTest() {
        server = new Socket();
        server.bind(new Host("localhost"), 8081);
        server.listen(10);

        while (true) {
            try {
                var socket:Socket = server.accept();
                var byteBuffer = Bytes.alloc(1024);
                var output:String;
                var bytesRead:Int = socket.input.readBytes(byteBuffer, 0, 1024);
                var byteString = Bytes.alloc(bytesRead);
                byteString.blit(0, byteBuffer, 0, bytesRead);
                output = byteString.toString();

                trace(output);
            }
        }
    }

}
