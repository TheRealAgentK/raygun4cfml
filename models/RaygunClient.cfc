/* 
Copyright 2021 Kai Koenig, Ventego Creative Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
component accessors="true" {

    property name="apiKey";
    property name="appVersion";
    property name="contentFilter";

	public RaygunClient function init(required string apiKey, RaygunContentFilter contentFilter, string appVersion) {

		variables.apiKey = arguments.apiKey;
        if (arguments.keyExists("contentFilter")) {
            variables.contentFilter = arguments.contentFilter;
        }
        if (arguments.keyExists("appVersion")) {
            variables.appVersion = arguments.appVersion;
        }

        return this;
	}

	public struct function send(required any issueDataStruct, RaygunUserCustomData userCustomData, array tags, RaygunIdentifierMessage user) {

        var apiKey = getApiKey();
        var contentFilter = getContentFilter();
        var appVersion = getAppVersion();
        var postResult = {};

		var message = new messages.RaygunMessage();

        // In certain newer versions of ACF, the passed in issueDataStruct is not editable in all cases anymore. 
        // It looks like a struct, but is of a different internal data type behind the scenes. This works around that issue.
        var issueData = structNew().append(arguments.issueDataStruct);

        if (!apiKey.len()) {
            throw("No API key provided, cannot send message to Raygun");
        }

        if (isObject(contentFilter)) {
            applyFilter(contentFilter);
        }

        if (appVersion.len()){
            issueData["appVersion"] = appVersion;

        // deal with custom data passed as an argument
        if (arguments.keyExists("userCustomData") && isObject(arguments.userCustomData)) {
            issueData["userCustomData"] = arguments.userCustomData;
        }
            
        // deal with tags passed as an argument
        if (arguments.keyExists("tags") && isArray(arguments.tags)) {
            issueData["tags"] = arguments.tags;
        }

        // deal with user identification data passed as an argument
        if (arguments.keyExists("user") && isObject(arguments.user)) {
            issueData["user"] = arguments.user;
        }

        // Build Crash Reporting message and serialize for http call
        var messageContent = message.build(duplicate(issueData));
        var jSONData = serializeJSON(messageContent);
        // Remove '//' in case CF is adding it when serializing JSON (which is recommended in the ACF Lockdown Guide)
        // This will only work if the user has setup none or the default prefix for JSON data
        jSONData = ReplaceNoCase(trim(jSONData), "//{", "{");
        jSONData = ReplaceNoCase(trim(jSONData), "//[", "[");
    
        cfhttp( charset="utf-8", url="https://api.raygun.io/entries", result="postResult", method="post" ) {
            cfhttpparam( name="Content-Type", type="header", value="application/json" );
            cfhttpparam( name="X-ApiKey", type="header", value=apiKey );
            cfhttpparam( type="body", value=jSONData );
        }

        return postResult;
	}

	private void function applyFilter(required RaygunContentFilter contentFilter) output=false {

		var defaultScopes = [url,form];
            var filter = arguments.contentFilter.getFilter();
            var match = {};
            var matchResult = "";

            for (var i=1; i<=ArrayLen(filter); i++)
            {
                // current filter object (filter,replacement)
                match = filter[i];

                // loop over scopes
                for (var j=1; j<=ArrayLen(defaultScopes); j++)
                {
                    // for each scope loop over keys
                    for (var key in defaultScopes[j])
                    {
                        matchResult = reMatchNoCase(match.filter,key);

                        if (isArray(matchResult) && ArrayLen(matchResult))
                        {
                            defaultScopes[j][key] = match.replacement;
                        }
                    }
                }
            }
	}

}
