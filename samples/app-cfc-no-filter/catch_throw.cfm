<!---
Copyright 2022 Kai Koenig, Ventego Creative Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--->
<cfscript>
    try {
        a = 14;
        b = 0;
        c = a/b;
    } catch(any e) {
        throw( 
            message = "This is a custom exception message", 
            type = "CustomException", 
            detail = "This is a custom exception detail", 
            errorcode = "1234567890", 
            extendedinfo = "The file catch_throw.cfm had an issue. Retrowing it.");
    }
</cfscript>