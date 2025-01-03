component {

    public RaygunRequestMessage function init() {
        return this;
    }

    public struct function build( struct settings = {} ) {
        var returnContent = {};

        try {
            var httpRequest = getHTTPRequestData();
        } catch ( any e ) {
            var httpRequest = {};
        }

        try {
            var localCGI = duplicate( CGI );
        } catch ( any e ) {
            var localCGI = {};
        }

        try {
            var localForm = duplicate( FORM );
        } catch ( any e ) {
            var localForm = {};
        }

        try {
            var localUrl = duplicate( URL );
        } catch ( any e ) {
            var localUrl = {};
        }

        returnContent = {
            "hostName" : ( localCGI.keyExists( "HTTP_HOST" ) ? localCGI.HTTP_HOST : javacast( "null", "" ) ),
            "url"      : ( localCGI.keyExists( "SCRIPT_NAME" ) ? localCGI.SCRIPT_NAME : javacast( "null", "" ) ) & (
                localCGI.keyExists( "PATH_INFO" ) ? localCGI.PATH_INFO : javacast( "null", "" )
            ),
            "httpMethod"  : ( localCGI.keyExists( "REQUEST_METHOD" ) ? localCGI.REQUEST_METHOD : javacast( "null", "" ) ),
            "iPAddress"   : ( localCGI.keyExists( "REMOTE_ADDR" ) ? localCGI.REMOTE_ADDR : javacast( "null", "" ) ),
            "queryString" : ( localCGI.keyExists( "QUERY_STRING" ) ? localCGI.QUERY_STRING : javacast( "null", "" ) ),
            "headers"     : ( httpRequest.keyExists( "headers" ) ? httpRequest.headers : javacast( "null", "" ) ),
            "data"        : localCGI,
            "form"        : localForm,
            "params"      : localUrl
        };

        if (
            localCGI.keyExists( "CONTENT_TYPE" ) && localCGI.keyExists( "REQUEST_METHOD" ) && localCGI.CONTENT_TYPE != "text/html" && localCGI.CONTENT_TYPE != "application/x-www-form-urlencoded" && localCGI.REQUEST_METHOD != "GET"
        ) {
            var maxLength = ( arguments.settings.keyExists( "rawDataMaxLength" ) ? arguments.settings.rawDataMaxLength : com.raygun.environment.RaygunConfig::getRawDataMaxLengthDefault() );
            returnContent[ "rawData" ] = Left( ( httpRequest.keyExists( "content" ) ) ? httpRequest.content : javacast( "null", "" ), maxLength );
        } else {
            returnContent[ "rawData" ] = javacast( "null", "" );
        }

        return returnContent;
    }

}
