component accessors="true" {

    property name="raygunExceptionMessage"   type="RaygunExceptionMessage";
    property name="raygunRequestMessage"     type="RaygunRequestMessage";
    property name="raygunClientMessage"      type="RaygunClientMessage";
    property name="raygunEnvironmentMessage" type="RaygunEnvironmentMessage";

    public RaygunMessageDetails function init(
        RaygunExceptionMessage raygunExceptionMessage     = new RaygunExceptionMessage(),
        RaygunRequestMessage raygunRequestMessage         = new RaygunRequestMessage(),
        RaygunClientMessage raygunClientMessage           = new RaygunClientMessage(),
        RaygunEnvironmentMessage raygunEnvironmentMessage = new RaygunEnvironmentMessage()
    ) {
        setRaygunExceptionMessage( arguments.raygunExceptionMessage );
        setRaygunRequestMessage( arguments.raygunRequestMessage );
        setRaygunClientMessage( arguments.raygunClientMessage );
        setRaygunEnvironmentMessage( arguments.raygunEnvironmentMessage );
        return this;
    }

    public struct function build(
        required struct issueData,
        struct settings = {}
    ) {
        var returnContent = {};

        if ( arguments.issueData.keyExists( "groupingKey" ) && arguments.issueData.groupingKey.len() ) {
            returnContent[ "groupingKey" ] = arguments.issueData.groupingKey;
        }

        if ( arguments.issueData.keyExists( "appVersion" ) ) {
            returnContent[ "version" ] = arguments.issueData.appVersion;
        } else {
            returnContent[ "version" ] = javacast( "null", "" );
        }

        try {
            returnContent[ "machineName" ] = createObject( "java", "java.net.InetAddress" ).getLocalHost().getHostAddress();
        } catch ( any e ) {
            returnContent[ "machineName" ] = CGI.SERVER_NAME;
        }

        returnContent[ "error" ]       = raygunExceptionMessage.build( arguments.issueData );
        returnContent[ "request" ]     = raygunRequestMessage.build( arguments.settings );
        returnContent[ "client" ]      = raygunClientMessage.build();
        returnContent[ "environment" ] = raygunEnvironmentMessage.build();

        if ( arguments.issueData.keyExists( "userCustomData" ) && isObject( arguments.issueData.userCustomData ) ) {
            returnContent[ "userCustomData" ] = arguments.issueData.userCustomData.build();
        } else {
            returnContent[ "userCustomData" ] = javacast( "null", "" );
        }

        if ( arguments.issueData.keyExists( "tags" ) && isArray( arguments.issueData.tags ) ) {
            returnContent[ "tags" ] = arguments.issueData.tags;
        } else {
            returnContent[ "tags" ] = [];
        }

        if ( arguments.issueData.keyExists( "user" ) && isObject( arguments.issueData.user ) ) {
            returnContent[ "user" ] = arguments.issueData.user.build();
        } else {
            returnContent[ "user" ] = javacast( "null", "" );
        }

        return returnContent;
    }

}
