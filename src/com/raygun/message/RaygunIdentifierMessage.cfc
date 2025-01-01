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

    property name="identifier" type="string" default="";
    property name="isAnonymous" type="boolean" default="";
    property name="email" type="string" default="";
    property name="fullName" type="string" default="";
    property name="firstName" type="string" default="";
    property name="uuid" type="string" default="";

    public RaygunIdentifierMessage function init() {
        return this;
    }

    public RaygunIdentifierMessage function identifier(string identifier) {
        setIdentifier(identifier);
        return this;
    }

    public RaygunIdentifierMessage function isAnonymous(boolean isAnonymous) {
        setIsAnonymous(isAnonymous);
        return this;
    }

    public RaygunIdentifierMessage function email(string email) {
        setEmail(email);
        return this;
    }

    public RaygunIdentifierMessage function fullName(string fullName) {
        setFullName(fullName);
        return this;
    }

    public RaygunIdentifierMessage function firstName(string firstName) {
        setFirstName(firstName);
        return this;
    }

    public RaygunIdentifierMessage function uuid(string uuid) {
        setUuid(uuid);
        return this;
    }

    public struct function build() {
        return {
            "identifier": getIdentifier(),
            "isAnonymous": getIsAnonymous(),
            "email": getEmail(),
            "fullName": getFullName(),
            "firstName": getFirstName(),
            "uuid": getUuid()
        };
    }
}
