component {

    static {
        RAW_DATA_MAX_LENGTH_DEFAULT = 4096;

        RAYGUN_CLIENT_NAME    = "raygun4cfml";
        RAYGUN_CLIENT_VERSION = "2.0.0-alpha";
        RAYGUN_CLIENT_URL     = "https://github.com/MindscapeHQ/raygun4cfml";
    }

    public static function getRawDataMaxLengthDefault() {
        return static.RAW_DATA_MAX_LENGTH_DEFAULT;
    }

    public static function getRaygunClientName() {
        return static.RAYGUN_CLIENT_NAME;
    }

    public static function getRaygunClientVersion() {
        return static.RAYGUN_CLIENT_VERSION;
    }

    public static function getRaygunClientUrl() {
        return static.RAYGUN_CLIENT_URL;
    }

}
