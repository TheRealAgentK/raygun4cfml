component accessors="true" {

    property name="raygunMessageDetails" type="RaygunMessageDetails";

    public RaygunMessage function init( RaygunMessageDetails raygunMessageDetails = new RaygunMessageDetails() ) {
        setRaygunMessageDetails( arguments.raygunMessageDetails );
        return this;
    }

    /**
     * Build the Raygun message structure
     *
     * @issueData The struct containing issue data augmented with Raygun-specific data
     */
    public struct function build(
        required struct issueData,
        struct settings = {}
    ) {
        var returnContent = {};
        var ts            = dateConvert( "local2Utc", now() );

        returnContent[ "occurredOn" ] = ts.dateFormat( "yyyy-mm-dd" ) & "T" & ts.timeFormat( "HH:mm:ss" ) & "Z";
        returnContent[ "details" ]    = raygunMessageDetails.build(
            arguments.issueData,
            arguments.settings
        );

        return returnContent;
    }

}
