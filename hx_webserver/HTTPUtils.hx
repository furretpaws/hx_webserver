package hx_webserver;

class HTTPUtils {
    public static function codeToMessage(code:Int):String {
        var message:String = "";
        switch(code) {
            case 100:
                message = "Continue";
            case 101:
                message = "Switching Protocols";
            case 102:
                message = "Processing";
            case 103:
                message = "Early Hints";
            case 200:
                message = "OK";
            case 201:
                message = "Created";
            case 202:
                message = "Accepted";
            case 203:
                message = "Non-authoritative Information";
            case 204:
                message = "No Content";
            case 205:
                message = "Reset Content";
            case 206:
                message = "Partial Content";
            case 207:
                message = "Multi-Status";
            case 208:
                message = "Already Reported";
            case 226:
                message = "IM Used";
            case 300:
                message = "Multiple Choices";
            case 301:
                message = "Moved Permanently";
            case 302:
                message = "Found";
            case 303:
                message = "See Other";
            case 304:
                message = "Not Modified";
            case 305:
                message = "Use Proxy";
            case 306:
                message = "unused";
            case 307:
                message = "Temporary Redirect";
            case 308:
                message = "Permanent Redirect";
            case 400:
                message = "Bad Request";
            case 401:
                message = "Unauthorized";
            case 402:
                message = "Payment Required";
            case 403:
                message = "Forbidden";
            case 404:
                message = "Not Found";
            case 405:
                message = "Method Not Allowed";
            case 406:
                message = "Not Acceptable";
            case 407:
                message = "Proxy Authentication Required";
            case 408:
                message = "Request Timeout";
            case 409:
                message = "Conflict";
            case 410:
                message = "Gone";
            case 411:
                message = "Length Required";
            case 412:
                message = "Precondition Failed";
            case 413:
                message = "Payload Too Large";
            case 414:
                message = "URI Too Long";
            case 415:
                message = "Unsupported Media Type";
            case 416:
                message = "Range Not Satisfiable";
            case 417:
                message = "Expectation Failed";
            case 418:
                message = "I'm a teapot";
            case 421:
                message = "Misdirected Request";
            case 422:
                message = "Unprocessable Content";
            case 423:
                message = "Locked";
            case 424:
                message = "Failed Dependency";
            case 425:
                message = "Too Early";
            case 426:
                message = "Upgrade Required";
            case 428:
                message = "Precondition Required";
            case 429:
                message = "Too Many Requests";
            case 431:
                message = "Request Header Fields Too Large";
            case 451:
                message = "Unavailable For Legal Reasons";
            case 500:
                message = "Internal Server Error";
            case 501:
                message = "Not Implemented";
            case 502:
                message = "Bad Gateway";
            case 503:
                message = "Service Unavailable";
            case 504:
                message = "Gateway Timeout";
            case 505:
                message = "HTTP Version Not Supported";
            case 506:
                message = "Variant Also Negotiates";
            case 507:
                message = "Insufficient Storage";
            case 508:
                message = "Loop Detected";
            case 510:
                message = "Not Extended";
            case 511:
                message = "Network Authentication Required";
        }
        return message;
    }

    //t- taken from hxdiscord 👉👈
    public static function getMimeType(file:String)
    {
        var mimetype:String = "";
        var split = file.split(".");
        switch(split[split.length - 1])
        {
            case "aac":
                mimetype = "audio/aac";
            case "abw":
                mimetype = "application/x-abiword";
            case "arc":
                mimetype = "application/x-freearc";
            case "avif":
                mimetype = "image/avif";
            case "avi":
                mimetype = "video/x-msvideo";
            case "azw":
                mimetype = "application/vnd.amazon.ebook";
            case "bin":
                mimetype = "application/octet-stream";
            case "bmp":
                mimetype = "image/bmp";
            case "bz":
                mimetype = "application/x-bzip";
            case "bz2":
                mimetype = "application/x-bzip2";
            case "cda":
                mimetype = "application/x-cdf";
            case "csh":
                mimetype = "application/x-csh";
            case "css":
                mimetype = "text/css";
            case "csv":
                mimetype = "text/csv";
            case "doc":
                mimetype = "application/msword";
            case "docx":
                mimetype = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            case "eot":
                mimetype = "application/vnd.ms-fontopbject";
            case "epub":
                mimetype = "application/epub+zip";
            case "gz":
                mimetype = "application/gzip";
            case "gif":
                mimetype = "image/gif";
            case "htm" | "html":
                mimetype = "text/html";
            case "ico":
                mimetype = "image/vnd.microsoft.icon";
            case "ics":
                mimetype = "text/calendar";
            case "jar":
                mimetype = "application/java-archive";
            case "jpeg" | "jpg":
                mimetype = "image/jpeg";
            case "js":
                mimetype = "text/javascript";
            case "json":
                mimetype = "application/json";
            case "jsonld":
                mimetype = "application/ls+json";
            case "mid" | "midi":
                mimetype = "audio/midi";
            case "mjs":
                mimetype = "text/javascript";
            case "mp3":
                mimetype = "audio/mpeg";
            case "mp4":
                mimetype = "video/mp4";
            case "mpeg":
                mimetype = "video/mpeg";
            case "mpkg":
                mimetype = "application/vnd.apple.installer+xml";
            case "odp":
                mimetype = "application/vnd.oasis.opendocument.presentation";
            case "ods":
                mimetype = "application/vnd.oasis.opendocument.spreadsheet";
            case "odt":
                mimetype = "application/vnd.oasis.opendocument.text";
            case "oga" | "ogg":
                mimetype = "audio/ogg";
            case "ogv":
                mimetype = "video/ogg";
            case "opus":
                mimetype = "audio/opus";
            case "otf":
                mimetype = "font/otf";
            case "png":
                mimetype = "image/png";
            case "pdf":
                mimetype = "application/pdf";
            case "php":
                mimetype = "application/x-httpd-php";
            case "ppt":
                mimetype = "application/vnd.ms-powerpoint";
            case "pptx":
                mimetype = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
            case "rar":
                mimetype = "application/vnd.rar";
            case "rtf":
                mimetype = "application/rtf";
            case "sh":
                mimetype = "application/x-sh";
            case "svg":
                mimetype = "image/svg+xml";
            case "tar":
                mimetype = "application/x-tar";
            case "tif" | "tiff":
                mimetype = "image/tiff";
            case "ts":
                mimetype = "video/mp2t";
            case "ttf":
                mimetype = "font/ttf";
            case "txt":
                mimetype = "text/plain";
            case "vsd":
                mimetype = "application/vnd.visio";
            case "wav":
                mimetype = "audio/wav";
            case "weba":
                mimetype = "audio/webm";
            case "webm":
                mimetype = "video/webm";
            case "webp":
                mimetype = "image/webp";
            case "woff":
                mimetype = "font/woff";
            case "woff2":
                mimetype = "font/woff2";
            case "xhtml":
                mimetype = "application/xhtml+xml";
            case "xls":
                mimetype = "application/vnd.ms-excel";
            case "xlsx":
                mimetype = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            case "xml":
                mimetype = "application/xml";
            case "xul":
                mimetype = "application/vnd.mozilla.xul+xml";
            case "zip":
                mimetype = "application/zip";
            case "3gp":
                mimetype = "video/3gpp";
            case "3g2":
                mimetype = "video/3gpp2";
            case "7z":
                mimetype = "application/x-7z-compressed";
            default:
                mimetype = "text/plain";
        }
        return mimetype;
    }
}