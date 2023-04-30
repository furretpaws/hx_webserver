package hx_webserver;


class HTTPResponse {

    public var statusCode: StatusCode;
    public var content: Dynamic;
    public var headers: Map<String, String>;

    public function new(
        statusCode: StatusCode = Ok,
        content: Dynamic = "",
        ?headers: Map<String, String>
    ) {
        this.statusCode = statusCode;
        this.content = content;
        this.headers = headers;
        if (this.headers == null) {
            this.headers = [];
        }
    }

    public function addHeader(key: String, value: String) {
        this.headers[key] = value;
    }

    public function addHeaderIfEmpty(key: String, value: String) {
        if (!this.headers.exists(key)) {
            this.headers[key] = value;
        }
    }

    public function prepare(): haxe.io.Bytes {
        var content: haxe.io.Bytes;
        switch (Type.typeof(this.content)) {
            case TClass(String):
                content = haxe.io.Bytes.ofString(this.content);
                this.addHeaderIfEmpty("Content-Type", "text/plain");
            case TClass(haxe.io.Bytes):
                content = this.content;
                if (!this.headers.exists("Content-Type")) {
                    throw "Bytes Response w/o Content-Type";
                }
            default:
                // TODO: should json be default?
                content = haxe.io.Bytes.ofString(
                    haxe.Json.stringify(this.content)
                );
                this.addHeaderIfEmpty("Content-Type", "application/json");
        }
        this.addHeaderIfEmpty("Content-Length", Std.string(content.length));

        var codeString = HTTPUtils.codeToMessage(this.statusCode);
        var out = new haxe.io.BytesOutput();
        out.writeString('HTTP/1.1 ${this.statusCode} $codeString\n');
        for (key => value in this.headers.keyValueIterator()) {
            out.writeString('$key: $value\n');
        }
        out.writeString("\n");
        out.write(content);
        out.writeString("\r\n");
        return out.getBytes();
    }
}
