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

    property name="apiKey"        type="string"              default="";
    property name="contentFilter" type="RaygunContentFilter" default="";
    property name="appVersion"    type="string"              default="";
    property name="settings"      type="RaygunSettings"      default="";

    public RaygunClient function init(
        required string apiKey,
        RaygunContentFilter contentFilter,
        string appVersion,
        RaygunSettings settings
    ) {
        setApiKey( arguments.apiKey );

        if ( arguments.keyExists( "contentFilter" ) ) {
            setContentFilter( arguments.contentFilter );
        }

        if ( arguments.keyExists( "appVersion" ) ) {
            setAppVersion( arguments.appVersion );
        }

        if ( arguments.keyExists( "settings" ) ) {
            setSettings( arguments.settings );
        }

        return this;
    }

    /**
     * Send error report to Raygun
     */
    public function send(
        required any issueData,
        RaygunUserCustomData userCustomData,
        array tags,
        RaygunIdentifierMessage user,
        string groupingKey,
        boolean sendAsync = false
    ) {
        var payloadArgs = { "issueData" : arguments.issueData };

        if ( arguments.keyExists( "userCustomData" ) ) {
            payloadArgs[ "userCustomData" ] = arguments.userCustomData;
        }

        if ( arguments.keyExists( "tags" ) && isArray( arguments.tags ) ) {
            payloadArgs[ "tags" ] = arguments.tags;
        }

        if ( arguments.keyExists( "user" ) ) {
            payloadArgs[ "user" ] = arguments.user;
        }

        if ( arguments.keyExists( "groupingKey" ) && arguments.groupingKey.len() ) {
            payloadArgs[ "groupingKey" ] = arguments.groupingKey;
        }

        var payload = buildPayload( argumentCollection = payloadArgs );

        if ( arguments.sendAsync ) {
            sendPayload( payload, arguments.sendAsync );
        } else {
            return sendPayload( payload, arguments.sendAsync );
        }
    }

    /**
     * Send error report to Raygun asynchronously, falls through to send()
     */
    public void function sendAsync(
        required any issueData,
        RaygunUserCustomData userCustomData,
        array tags,
        RaygunIdentifierMessage user,
        string groupingKey
    ) {
        arguments[ "sendAsync" ] = true;
        send( argumentCollection = arguments );
    }

    /**
     * Build the payload for Raygun
     */
    private string function buildPayload(
        required any issueData,
        RaygunUserCustomData userCustomData,
        array tags,
        RaygunIdentifierMessage user,
        string groupingKey
    ) {
        var issueData = {};
        issueData.append( arguments.issueData );

        if ( !getApiKey().len() ) {
            throw( "API key not set, cannot send message to Raygun" );
        }

        if ( getAppVersion().len() ) {
            issueData[ "appVersion" ] = getAppVersion();
        }

        if ( arguments.keyExists( "userCustomData" ) ) {
            issueData[ "userCustomData" ] = arguments.userCustomData;
        }

        if ( arguments.keyExists( "tags" ) && isArray( arguments.tags ) ) {
            issueData[ "tags" ] = arguments.tags;
        }

        if ( arguments.keyExists( "user" ) ) {
            issueData[ "user" ] = arguments.user;
        }

        if ( arguments.keyExists( "groupingKey" ) && arguments.groupingKey.len() ) {
            issueData[ "groupingKey" ] = arguments.groupingKey;
        }

        var message        = new message.RaygunMessage();
        var raygunSettings = {};
        if ( isInstanceOf( getSettings(), "RaygunSettings" ) ) {
            var raygunSettings = getSettings().getSettings();
        }
        var messageContent = message.build(
            issueData.duplicate(),
            raygunSettings
        );

        if (
            isInstanceOf(
                getContentFilter(),
                "RaygunContentFilter"
            )
        ) {
            messageContent = getContentFilter().apply( messageContent );
        }

        var jsonData = messageContent.toJSON();

        // Adobe CF workaround:
        //
        // Remove '//' in case ACF is adding it when serializing JSON (which is suggested to be set up in the ACF Lockdown Guide)
        // I believe actually following the Lockdown Guide's suggestion is not a good idea, but some users might have set up a custom prefix for JSON data serialization.
        //
        // Notes:
        //
        // - This will only work if the user has setup none or the default prefix for JSON data.
        // - If the user has setup a custom prefix like '--abc', this will not work and the user will need to manually remove the prefix.
        jsonData = jsonData
            .trim()
            .replaceNoCase( "//{", "{" )
            .replaceNoCase( "//[", "[" );

        return jsonData;
    }

    /**
     * Send the payload to Raygun
     */
    private any function sendPayload(
        required string jsonData,
        boolean sendAsync = false
    ) {
        var postResult = "";

        if ( arguments.sendAsync ) {
            thread action="run" name="sendAsyncToRaygunThead_#createUUID()#" apiKey=getApiKey() payload=arguments.jsonData {
                try {
                    cfhttp(
                        url          = "https://api.raygun.com/entries",
                        method       = "post",
                        charset      = "utf-8",
                        throwOnError = true
                    ) {
                        cfhttpparam(
                            type  = "header",
                            name  = "Content-Type",
                            value = "application/json"
                        );
                        cfhttpparam(
                            type  = "header",
                            name  = "X-ApiKey",
                            value = "#attributes.apiKey#"
                        );
                        cfhttpparam(
                            type  = "body",
                            value = "#attributes.payload#"
                        );
                    }
                } catch ( any e ) {
                    writeLog(
                        text = "Error when trying to send to Raygun async: #serializeJSON( e )#",
                        type = "error",
                        file = "Raygun4CFML"
                    );
                }
            }
        } else {
            cfhttp(
                url     = "https://api.raygun.com/entries",
                method  = "post",
                charset = "utf-8",
                result  = "postResult"
            ) {
                cfhttpparam(
                    type  = "header",
                    name  = "Content-Type",
                    value = "application/json"
                );
                cfhttpparam(
                    type  = "header",
                    name  = "X-ApiKey",
                    value = getApiKey()
                );
                cfhttpparam(
                    type  = "body",
                    value = "#arguments.jsonData#"
                );
            }
        }

        return postResult;
    }

}
