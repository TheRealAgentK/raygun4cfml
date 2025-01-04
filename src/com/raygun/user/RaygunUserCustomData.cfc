/**
 * Handles custom user data for Raygun error reports.
 * Allows developers to attach arbitrary diagnostic information to error reports
 * to provide additional context about the state of the application when an error occurred.
 * This data appears in the "Custom Data" tab in the Raygun dashboard.
 */
component accessors="true" {

    // Stores arbitrary key-value pairs that will be included in the error report
    property name="userCustomData" type="struct";

    public RaygunUserCustomData function init( struct userCustomData = {} ) {
        setUserCustomData( userCustomData );
        return this;
    }

    /**
     * Returns the custom data structure for inclusion in the error payload.
     * Called during error report construction to attach the custom data.
     */
    public function build() {
        return getUserCustomData();
    }

}
