/**
 * Copyright 2025 Kai Koenig, Ventego Creative Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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
            var maxLength = ( arguments.settings.keyExists( "rawDataMaxLength" ) ? arguments.settings.rawDataMaxLength : com.raygun.environment.RaygunConfig::RAW_DATA_MAX_LENGTH_DEFAULT );
            returnContent[ "rawData" ] = Left( ( httpRequest.keyExists( "content" ) ) ? httpRequest.content : javacast( "null", "" ), maxLength );
        } else {
            returnContent[ "rawData" ] = javacast( "null", "" );
        }

        return returnContent;
    }

}
