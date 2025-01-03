component accessors="true" {

    property name="rawDataMaxLength" type="numeric";

    public RaygunSettings function init( numeric rawDataMaxLength = com.raygun.environment.RaygunConfig::RAW_DATA_MAX_LENGTH_DEFAULT ) {
        setRawDataMaxLength( rawDataMaxLength );
        return this;
    }

    public struct function getSettings() {
        return { "rawDataMaxLength" : getRawDataMaxLength() };
    }

}
