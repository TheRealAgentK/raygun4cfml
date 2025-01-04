/**
 * Processes HTTP request data for Raygun error reports.
 * Captures essential request context including headers, form data, and raw request content
 * while gracefully handling cases where certain scopes might be unavailable.
 */
component {

    public RaygunRequestMessage function init() {
        return this;
    }

    /**
     * Builds a comprehensive snapshot of the HTTP request state.
     * Uses multiple data sources (CGI, FORM, URL scopes) with fallbacks to ensure
     * we capture as much context as possible even if some scopes are restricted.
     * Raw request data is truncated to prevent oversized payloads.
     *
     * @settings Optional configuration settings, primarily for controlling raw data length
     */
    public struct function build( struct settings = {} ) {
        var returnContent = {};

        // Safely access request data - some environments restrict getHTTPRequestData()
        try {
            var httpRequest = getHTTPRequestData();
        } catch ( any e ) {
            var httpRequest = {};
        }

        // CGI scope access may be restricted in some locked-down environments
        // Todo: This is currently an issue in Boxlang 1.0.0 (see Boxlang Jira BL-901 and -902)`
        try {
            var localCGI = duplicate( CGI );
        } catch ( any e ) {
            var localCGI = {};
        }

        // Form scope might not exist for non-POST requests
        try {
            var localForm = duplicate( FORM );
        } catch ( any e ) {
            var localForm = {};
        }

        // URL parameters might be empty or restricted
        try {
            var localUrl = duplicate( URL );
        } catch ( any e ) {
            var localUrl = {};
        }

        // Build core request data, defaulting to null for missing values to maintain API compatibility
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

        // Only include raw request data for non-standard content types to avoid duplicating form data
        // Also enforces a max length to prevent oversized payloads
        if (
            localCGI.keyExists( "CONTENT_TYPE" ) && localCGI.keyExists( "REQUEST_METHOD" ) && localCGI.CONTENT_TYPE != "text/html" && localCGI.CONTENT_TYPE != "application/x-www-form-urlencoded" && localCGI.REQUEST_METHOD != "GET"
        ) {
            var maxLength = (
                arguments.settings.keyExists( "rawDataMaxLength" ) ? arguments.settings.rawDataMaxLength : com.raygun.environment.RaygunConfig::getRawDataMaxLengthDefault()
            );
            returnContent[ "rawData" ] = left(
                ( httpRequest.keyExists( "content" ) ) ? httpRequest.content : javacast( "null", "" ),
                maxLength
            );
        } else {
            returnContent[ "rawData" ] = javacast( "null", "" );
        }

        return returnContent;
    }

}
