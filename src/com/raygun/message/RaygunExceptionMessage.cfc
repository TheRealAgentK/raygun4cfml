component {

    public RaygunExceptionMessage function init() {
        return this;
    }

    public struct function build( required struct issueData ) {
        var returnContent  = {};
        var tagContextData = [];
        var stackTraceData = [];
        var isLucee = com.raygun.tools.RaygunInternalTools::isLucee();
        var isACF2021 = com.raygun.tools.RaygunInternalTools::isACF2021();

        var entryPoint = arguments.issueData;

        writeDump( issueData );
        if ( entryPoint.keyExists( "Cause" ) && entryPoint.cause.keyExists( "CatchBlock" ) ) {
            entryPoint = entryPoint.cause.CatchBlock;
        }

        if ( isArray( entryPoint.stacktrace ) ) {
            var stackTraceData = entryPoint.stacktrace;
        } else if ( isSimpleValue( entryPoint.stacktrace ) ) {
            // This is typically the case for Lucee's Java-like stack traces
            var stackTraceLines = entryPoint.stacktrace.split( "\sat" );
            writeDump( stackTraceLines );

            for ( var j = 2; j <= arrayLen( stackTraceLines ); j++ ) {
                // This split leaves the package path and function name in the first element
                // and the file name and line number in the second element
                var stackTraceLineElements = stackTraceLines[ j ].split( "\(" );
                writeDump( stackTraceLineElements );
                if ( arrayLen( stackTraceLineElements ) == 2 ) {
                    var stackTraceLineElement             = {};
                    stackTraceLineElement[ "methodName" ] = trim( stackTraceLineElements[ 1 ] ).listLast( "." );
                    stackTraceLineElement[ "className" ]  = stackTraceLineElements[ 1 ]
                        .listDeleteAt(
                            stackTraceLineElements[ 1 ].listLen( "." ),
                            "."
                        )
                        .trim();

                    // There are Java stack traces without line numbers. Check if a line number is present.
                    // We look for a colon followed by digits. If there is no line number, return Null so it's clear that none was given.
                    if ( stackTraceLineElements[ 2 ].reFindNoCase( "\:(?!\D+)" ) ) {
                        var parts                             = stackTraceLineElements[ 2 ].split( "\:(?!\D+)" );
                        stackTraceLineElement[ "fileName" ]   = parts[ 1 ].reReplace( "[\)\n\r]", "" ).trim();
                        stackTraceLineElement[ "lineNumber" ] = parts[ 2 ].reReplace( "[\)\n\r]", "" ).trim();
                    } else {
                        stackTraceLineElement[ "fileName" ]   = stackTraceLineElements[ 2 ].reReplace( "[\)\n\r]", "" ).trim();
                        stackTraceLineElement[ "lineNumber" ] = javacast( "null", "" );
                    }

                    stackTraceData.append( stackTraceLineElement );
                }
            }
        }

        // TagContext is different between Lucee and ACF
        if (isLucee) {
            // Lucee
            if ( entryPoint.keyExists( "tagcontext" ) ) {
                for ( j = 1; j <= entryPoint.tagcontext.len(); j++ ) {
                    tagContextData[ j ] = {
                        "code"       : chr( 13 ) & "      " & entryPoint.tagcontext[ j ][ "codePrintPlain" ].trim(),
                        "className"  : entryPoint.tagcontext[ j ][ "id" ].trim(),
                        "fileName"   : entryPoint.tagcontext[ j ][ "template" ].trim(),
                        "lineNumber" : trim( entryPoint.tagcontext[ j ][ "line" ] )
                    };
                }
            }
        } else if (isACF2021) {
            // ACF 2021
            if ( entryPoint.keyExists( "tagcontext" ) ) {
                for ( j = 1; j <= entryPoint.tagcontext.len(); j++ ) {
                    tagContextData[ j ] = {
                        "className"  : entryPoint.tagcontext[ j ][ "id" ].trim(),
                        "fileName"   : entryPoint.tagcontext[ j ][ "template" ].trim(),
                        "lineNumber" : trim( entryPoint.tagcontext[ j ][ "line" ] )
                    };
                }
            }
        }

        returnContent[ "data" ][ "tagContext" ] = ( arrayLen( tagContextData ) ? tagContextData : "" );
        returnContent[ "data" ][ "errorCode" ] = ( entryPoint.keyExists( "errorcode" ) && len( entryPoint.errorcode ) && entryPoint.errorcode != 0 ) ? entryPoint.errorcode : "";
        returnContent[ "data" ][ "extendedInfo" ] = ( entryPoint.keyExists( "extendedinfo" ) && entryPoint.extendedinfo.len() ) ? entryPoint.extendedinfo : "";

        returnContent[ "stackTrace" ] = stackTraceData;
        returnContent[ "message" ]    = entryPoint.message;
        returnContent[ "className" ]  = entryPoint.type.trim();

        // // If there is a root cause, we can use it to get the type and message
        // if (entryPoint.keyExists("RootCause")) {
        //     if (entryPoint["RootCause"].keyExists("Type") && entryPoint["RootCause"]["Type"] == "expression") {
        //         returnContent["data"]["type"] = entryPoint["RootCause"]["Type"];
        //     }
        //     if (entryPoint["RootCause"].keyExists("Message")) {
        //         returnContent["message"] = entryPoint["RootCause"]["Message"];
        //     }
        // } else {
        //     // otherwise there's no root cause and the specific data has to be grabbed from somewhere else
        //     if (!isLucee || isACF2021) {
        //         returnContent["data"]["type"] = entryPoint.type;
        //     }
        //     returnContent["message"] = entryPoint.message;
        // }

        if ( entryPoint.type == "database" ) {
            if ( !returnContent[ "message" ].len() ) returnContent[ "message" ] = "SQL/DB issue";

            var databaseData = {};
            returnContent[ "data" ][ "database" ][ "detail" ] = ( entryPoint.keyExists( "detail" ) && entryPoint.detail.len() ) ? entryPoint.detail : "";
            returnContent[ "data" ][ "database" ][ "sql" ] = ( entryPoint.keyExists( "sql" ) && entryPoint.sql.len() ) ? entryPoint.sql : "";
            returnContent[ "data" ][ "database" ][ "queryError" ] = ( entryPoint.keyExists( "queryError" ) && entryPoint.queryError.len() ) ? entryPoint.queryError : "";
            returnContent[ "data" ][ "database" ][ "nativeErrorCode" ] = ( entryPoint.keyExists( "nativeErrorCode" ) && len( entryPoint.nativeErrorCode ) ) ? entryPoint.nativeErrorCode : "";
            returnContent[ "data" ][ "database" ][ "SQLState" ] = ( entryPoint.keyExists( "SQLState" ) && entryPoint.SQLState.len() ) ? entryPoint.SQLState : "";
            returnContent[ "data" ][ "database" ] = databaseData;
        }
        writeDump( returnContent )
        return returnContent;
    }

}
