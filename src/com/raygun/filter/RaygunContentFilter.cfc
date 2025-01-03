component accessors="true" {

    property name="filter" type="array";

    public RaygunContentFilter function init( array filter = [] ) {
        setFilter( filter );
        return this;
    }

    /**
     * Apply content filtering
     */
    public struct function apply( required struct messageData ) {
        var filter = getFilter();

        for ( var matcher in filter ) {
            var findKeysByFilter = arguments.messageData.findKey( matcher.filter, "all" );

            // loop over general found keys and replace
            for ( var element in findKeysByFilter ) {
                // generally we only want to replace simple values, not structs or arrays, as the replacement value is a string.
                if ( isSimpleValue( element.value ) ) {
                    element.owner[ matcher.filter ] = matcher.replacement;
                }
            }

            // special case - rawData might be JSON
            if ( !isNull( arguments.messageData.details.request.rawData ) && isJSON( arguments.messageData.details.request.rawData ) ) {
                var rawDataJSON             = arguments.messageData.details.request.rawData.deserializeJSON();
                var findRawDataKeysByFilter = rawDataJSON.findKey( matcher.filter, "all" );

                // loop over finds in the jsonified rawData and replace
                for ( var element in findRawDataKeysByFilter ) {
                    element.owner[ matcher.filter ] = matcher.replacement;
                }
                arguments.messageData.details.request.rawData = rawDataJSON.serializeJSON();
            }
        }

        return arguments.messageData;
    }

}
