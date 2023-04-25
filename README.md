# hx_webserver

A basic HTTP server library for Haxe (HTTP only)

## Installation

Use the package manager [haxelib](https://lib.haxe.org) to install hx_webserver.

```bash
haxelib install hx_webserver
haxelib git hx_webserver https://github.com/FurretDev/hx_webserver.git
```
## Disclaimer
This library is not meant to be used for production use since it's still in development. (However it's still usable)
## Usage

Responding with a simple text
```haxe
import hx_webserver.HTTPServer;
import hx_webserver.HTTPRequest;

class Main {
    static var Server:HTTPServer;

    static function main() {
        Server = new HTTPServer("0.0.0.0", 80, true/*, false*/);
        Server.onClientConnect = (d:HTTPRequest) -> {
            d.reply("Hello!");
        }
    }
}
```

Responding with a file
```haxe
import hx_webserver.HTTPServer;
import hx_webserver.HTTPRequest;

class Main {
    static var Server:HTTPServer;

    static function main() {
        Server = new HTTPServer("0.0.0.0", 80, true/*, false*/);
        Server.onClientConnect = (d:HTTPRequest) -> {
            d.replyWithFile("index.html");
            //NOTE: If the file doesn't exist it won't give an 404 error.
            //You'll have to code that by yourself
        }
    }
}
```

Responding with the URL file requested
Responding with a file
```haxe
import hx_webserver.HTTPServer;
import hx_webserver.HTTPRequest;

class Main {
    static var Server:HTTPServer;

    static function main() {
        Server = new HTTPServer("0.0.0.0", 80, true/*, false*/);
        Server.onClientConnect = (d:HTTPRequest) -> {
            d.replyWithFile(d.methods[1].substr(1));
            //NOTE: If the file doesn't exist it won't give an 404 error.
            //You'll have to code that by yourself
        }
    }
}
```

## Contributing

Contributions (pull requests) are always welcome, we appreciate every contribution <3

## License

[MIT](https://choosealicense.com/licenses/mit/)