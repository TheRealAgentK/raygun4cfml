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

/**
 * Test suite for RaygunUserCustomData component which handles custom user data validation and building.
 * Custom data must be a struct to maintain consistency with Raygun's API expectations and
 * to ensure proper JSON serialization when sending error reports.
 */
component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "RaygunUserCustomData", () => {
            beforeEach( () => {
                variables.raygunUserCustomData = new com.raygun.user.RaygunUserCustomData();
            } );

            it( "should be a component", () => {
                expect( raygunUserCustomData ).toBeComponent();
            } );

            // Arrays are rejected because Raygun's API expects a flat key-value structure for custom data
            it( "should fail if incorrect data type array is provided", () => {
                expect( () => raygunUserCustomData.setUserCustomData( [ { "test" : "test" } ] ).build() ).toThrow();
            } );

            // Strings are rejected as they cannot represent the key-value pairs needed for custom data
            it( "should fail if incorrect data type string is provided", () => {
                expect( () => raygunUserCustomData.setUserCustomData( "My Data" ).build() ).toThrow();
            } );

            // Structs are the correct format as they match Raygun's API requirements
            it( "should not fail if correct data type struct is provided", () => {
                expect( () => raygunUserCustomData.setUserCustomData( { "test" : "test" } ).build() ).notToThrow();
            } );

            // Verifies that custom data is preserved exactly as provided
            it( "should return the correct data", () => {
                expect( raygunUserCustomData.setUserCustomData( { "test" : "test" } ).build() ).toBe( { "test" : "test" } );
            } );

            // Default state returns empty struct to maintain consistent return type
            it( "should create an empty struct on .build() without data", () => {
                expect( raygunUserCustomData.build() ).toBe( {} );
            } );
        } );
    }

}

