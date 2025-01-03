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