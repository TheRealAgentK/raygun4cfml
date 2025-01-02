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

    property name="raygunExceptionMessage" type="RaygunExceptionMessage";
    property name="raygunRequestMessage" type="RaygunRequestMessage";
    property name="raygunClientMessage" type="RaygunClientMessage"; 
    property name="raygunEnvironmentMessage" type="RaygunEnvironmentMessage";

    public RaygunMessageDetails function init(
        RaygunExceptionMessage raygunExceptionMessage = new RaygunExceptionMessage(),
        RaygunRequestMessage raygunRequestMessage = new RaygunRequestMessage(),
        RaygunClientMessage raygunClientMessage = new RaygunClientMessage(),
        RaygunEnvironmentMessage raygunEnvironmentMessage = new RaygunEnvironmentMessage()
    ) {
        setRaygunExceptionMessage(arguments.raygunExceptionMessage);
        setRaygunRequestMessage(arguments.raygunRequestMessage);
        setRaygunClientMessage(arguments.raygunClientMessage);
        setRaygunEnvironmentMessage(arguments.raygunEnvironmentMessage);
        return this;
    }

    public struct function build(required struct issueData) {
        var returnContent = {};

        if (arguments.issueData.keyExists("groupingKey") && arguments.issueData.groupingKey.len()) {
            returnContent["groupingKey"] = arguments.issueData.groupingKey;
        }

        if (arguments.issueData.keyExists("appVersion")) {
            returnContent["version"] = arguments.issueData.appVersion;
        } else {
            returnContent["version"] = JavaCast("null", "");
        }

        try {
            returnContent["machineName"] = CreateObject("java", "java.net.InetAddress").getLocalHost().getHostAddress();
        } catch (any e) {
            returnContent["machineName"] = CGI.SERVER_NAME;
        }

        returnContent["error"] = raygunExceptionMessage.build(arguments.issueData);
        returnContent["request"] = raygunRequestMessage.build();
        returnContent["client"] = raygunClientMessage.build();
        returnContent["environment"] = raygunEnvironmentMessage.build();

        if (arguments.issueData.keyExists("userCustomData") && isObject(arguments.issueData.userCustomData)) {
            returnContent["userCustomData"] = arguments.issueData.userCustomData.build();
        } else {
            returnContent["userCustomData"] = JavaCast("null", "");
        }

        if (arguments.issueData.keyExists("tags") && isArray(arguments.issueData.tags)) {
            returnContent["tags"] = arguments.issueData.tags;
        } else {
            returnContent["tags"] = [];
        }

        if (arguments.issueData.keyExists("user") && isObject(arguments.issueData.user)) {
            returnContent["user"] = arguments.issueData.user.build();
        } else {
            returnContent["user"] = JavaCast("null", "");
        }

        return returnContent;
    }
}
