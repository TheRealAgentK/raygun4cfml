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
component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "RaygunUserCustomData", () => {
            beforeEach( () => {
                variables.raygunUserCustomData = new com.raygun.user.RaygunUserCustomData();
            } );

            it( "should be a component", () => {
                expect( raygunUserCustomData ).toBeComponent();
            } );

            it( "should fail if incorrect data type array is provided", () => {
                expect( () => raygunUserCustomData.userCustomData( [ { "test" : "test" } ] ).build() ).toThrow();
            } );

            it( "should fail if incorrect data type string is provided", () => {
                expect( () => raygunUserCustomData.userCustomData( "My Data" ).build() ).toThrow();
            } );

            it( "should not fail if correct data type struct is provided", () => {
                expect( () => raygunUserCustomData.userCustomData( { "test" : "test" } ).build() ).notToThrow();
            } );

            it( "should return the correct data", () => {
                expect( raygunUserCustomData.userCustomData( { "test" : "test" } ).build() ).toBe( { "test" : "test" } );
            } );
        } );
    }

}


