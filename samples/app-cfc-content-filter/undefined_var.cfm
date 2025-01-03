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