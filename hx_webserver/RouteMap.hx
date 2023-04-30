package hx_webserver;

typedef RouteHandler = HTTPRequest -> HTTPResponse;


class RouteMap {

    private var routes: Map<String, RouteHandler> = [];

    public function new() {
    }

    public function add(route: String, handler: RouteHandler) {
        this.routes[route] = handler;
    }

    public function attach(server: HTTPServer) {
        server.onClientConnect = this.routeRequest;
    }

    private function routeRequest(request: HTTPRequest) {
        var path = request.methods[1];
        var handler = this.routes.get(path);

        var response: HTTPResponse;
        if (handler != null) {
            try {
                response = handler(request);
            } catch (exception) {
                response = new HTTPResponse(
                    InternalServerError,
                    "Internal Server Error",
                );
            }
        } else {
            response = new HTTPResponse(NotFound);
        }
        if (response == null) {
            response = new HTTPResponse(NoContent);
        }
        request.replyRaw(response.prepare());
    }

}
