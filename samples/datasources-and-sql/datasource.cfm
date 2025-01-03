<cfset RAYGUNAPIKEY = "V84wUYVR5lWGHgVMq5Cxig">
<cftry>
    <cfquery datasource="something">
        SELECT glarfx bo banana
    </cfquery> 
    <cfcatch type="any">
        <cfdump var="#cfcatch#">
        <cfscript>
            raygun = new com.raygun.RaygunClient(apiKey = RAYGUNAPIKEY, appVersion = "3.4.7");
            result = raygun.send(cfcatch);
        </cfscript>
    </cfcatch>
</cftry> 