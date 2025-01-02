<!---
Copyright 2025 Kai Koenig, Ventego Creative Ltd

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
    //  Create some fake values in the form and url scopes to test the content filter
    form["age"] = 38;

    // Option 1: 
    // This will be filtered out (see Application.cfc) and replaced with the replacement string.
    // form["password"] = "gfgfdgfdgfdgfd";

    // Option 2: 
    // This will be filtered out (see Application.cfc) and not replaced with the replacement string. If the nested struct contains simple values matching the filter, they will be replaced.
    form["password"] = { "a" = 4, "b" = 5 };

    form["ASecretPasswordThing"] = "gfgfgfdfgdw432443543";
    url["creditcard"] = "6565654";

    // This will error, because test5678 is not defined.
    writeOutput(test5678);
</cfscript>