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

    property name="raygunMessageDetails" type="RaygunMessageDetails";

    public RaygunMessage function init( RaygunMessageDetails raygunMessageDetails = new RaygunMessageDetails() ) {
        setRaygunMessageDetails( arguments.raygunMessageDetails );
        return this;
    }

    /**
     * Build the Raygun message structure
     *
     * @issueData The struct containing issue data augmented with Raygun-specific data
     */
    public struct function build(
        required struct issueData,
        struct settings = {}
    ) {
        var returnContent = {};
        var ts            = dateConvert( "local2Utc", now() );

        returnContent[ "occurredOn" ] = ts.dateFormat( "yyyy-mm-dd" ) & "T" & ts.timeFormat( "HH:mm:ss" ) & "Z";
        returnContent[ "details" ]    = raygunMessageDetails.build(
            arguments.issueData,
            arguments.settings
        );

        return returnContent;
    }

}
