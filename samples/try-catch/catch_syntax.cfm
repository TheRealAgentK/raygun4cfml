<cfscript>
    RAYGUNAPIKEY = "V84wUYVR5lWGHgVMq5Cxig";

    // Adobe ColdFusion compiles this code and then fails at runtime. So, ACF will log this to Raygun just fine.
    //
    // Lucee however will fail at compile time and not execute the code - so it will not log to Raygun in here. 
    // If you had a global error handler in Lucee or on the servlet engine, it could be caught there.
    try {
        a = 14;
        b z 0;
    } catch(any e) {
        raygun = new com.raygun.RaygunClient(
            apiKey = RAYGUNAPIKEY,
            appVersion = "3.4.5"
        );
        result = raygun.send(e);
    }
</cfscript>