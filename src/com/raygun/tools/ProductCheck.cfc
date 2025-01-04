/**
 * ProductCheck Component
 * Provides functionality to detect and retrieve information about the CFML server environment.
 * This is crucial for compatibility checks and server-specific behavior implementations.
 */
component {

    static {
        // Create an immutable copy of the server scope to prevent any accidental modifications
        // during runtime while accessing server information
        serverScope = duplicate( server );
    }

    /**
     * Determines the running CFML server type and version
     * Returns standardized server information to ensure consistent handling across different CFML engines
     * Supports Boxlang, Lucee, and Adobe ColdFusion (ACF) detection
     * 
     * @return struct Contains normalized server information including engine type and version details
     */
    public static function getServerProductInfo() {
        var cfProductName = static.serverScope.ColdFusion.ProductName;

        // Check for Boxlang first as it's a special case that doesn't follow standard naming conventions
        if ( static.serverScope.keyExists( "boxlang" ) ) {
            return {
                "cfServer"          : "Boxlang",
                "serverVersion"     : static.serverScope.boxlang.version,
                "serverMainVersion" : static.serverScope.boxlang.version.listFirst( "." )
            };
        } else if ( cfProductName.contains( "Lucee" ) ) {
            return {
                "cfServer"          : "Lucee",
                "serverVersion"     : static.serverScope.lucee.version,
                "serverMainVersion" : static.serverScope.lucee.version.listFirst( "." )
            };
        } else if ( cfProductName.contains( "ColdFusion" ) ) {
            // ACF requires additional product level information for proper version handling
            return {
                "cfServer"          : "ACF",
                "serverVersion"     : static.serverScope.coldfusion.productversion,
                "serverMainVersion" : static.serverScope.coldfusion.productversion.listFirst(),
                "productLevel"      : static.serverScope.coldfusion.productlevel
            };
        } else {
            // Fallback for unknown server types to prevent errors in calling code
            return {
                "cfServer"      : "",
                "serverVersion" : ""
            };
        }
    }

}
