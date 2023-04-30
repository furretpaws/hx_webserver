package hx_webserver.test;


import sys.net.Socket;
import sys.net.Host;
import haxe.io.Bytes;
import haxe.io.Error;


class Main {

  static var server: Socket;

  static function main() {
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
