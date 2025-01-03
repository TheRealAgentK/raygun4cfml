<cfscript>
    RAYGUNAPIKEY = "V84wUYVR5lWGHgVMq5Cxig";

    try {
        a = 14;
        b = 0;
        c = a/b;
    } catch(any e) {
        raygun = new com.raygun.RaygunClient(
            apiKey = RAYGUNAPIKEY,
            appVersion = "3.4.5"
        );
        result = raygun.send(e);
    }
</cfscript>