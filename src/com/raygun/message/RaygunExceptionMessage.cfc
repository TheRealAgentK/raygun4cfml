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
component accessors="true" {

    public RaygunExceptionMessage function init() {
        return this;
    }

    public struct function build( required struct issueData ) {
        var returnContent  = {};
        var tagContextData = [];
        var stackTraceData = [];
        // var isLucee = new RaygunInternalTools().isLucee();
        // var isACF2021 = new RaygunInternalTools().isACF2021();

        var entryPoint = arguments.issueData;

        dump( issueData );
        if ( entryPoint.keyExists( "Cause" ) && entryPoint.cause.keyExists( "CatchBlock" ) ) {
            entryPoint = entryPoint.cause.CatchBlock;
        }

        if ( isArray( entryPoint.stacktrace ) ) {
            var stackTraceData = entryPoint.stacktrace;
        } else if ( isSimpleValue( entryPoint.stacktrace ) ) {
            // This is typically the case for Lucee's Java-like stack traces
            var stackTraceLines = entryPoint.stacktrace.split( "\sat" );
            dump( stackTraceLines );

            for ( var j = 2; j <= arrayLen( stackTraceLines ); j++ ) {
                // This split leaves the package path and function name in the first element
                // and the file name and line number in the second element
                var stackTraceLineElements = stackTraceLines[ j ].split( "\(" );
                dump( stackTraceLineElements );
                if ( arrayLen( stackTraceLineElements ) == 2 ) {
                    var stackTraceLineElement             = {};
                    stackTraceLineElement[ "methodName" ] = trim( stackTraceLineElements[ 1 ].listLast( "." ) );
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

        arrayLen( tagContextData ) ? returnContent[ "data" ][ "tagContext" ] = tagContextData : "";
        entryPoint.keyExists( "errorcode" ) && len( entryPoint.errorcode ) && entryPoint.errorcode != 0 ? returnContent[ "data" ][ "errorCode" ] = entryPoint.errorcode : "";
        entryPoint.keyExists( "extendedinfo" ) && entryPoint.extendedinfo.len() ? returnContent[ "data" ][ "extendedInfo" ] = entryPoint.extendedinfo : "";

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
            entryPoint.keyExists( "detail" ) && entryPoint.detail.len() ? databaseData[ "detail" ] = entryPoint.detail : "";
            entryPoint.keyExists( "sql" ) && entryPoint.sql.len() ? databaseData[ "sql" ] = entryPoint.sql : "";
            entryPoint.keyExists( "queryError" ) && entryPoint.queryError.len() ? databaseData[ "queryError" ] = entryPoint.queryError : "";
            entryPoint.keyExists( "nativeErrorCode" ) && len( entryPoint.nativeErrorCode ) ? databaseData[ "nativeErrorCode" ] = entryPoint.nativeErrorCode : "";
            entryPoint.keyExists( "SQLState" ) && entryPoint.SQLState.len() ? databaseData[ "SQLState" ] = entryPoint.SQLState : "";
            returnContent[ "data" ][ "database" ] = databaseData;
        }
        dump( returnContent )
        return returnContent;
    }

}
