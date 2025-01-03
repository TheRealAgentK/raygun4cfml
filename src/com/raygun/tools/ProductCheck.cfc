component {

    static {
        serverScope = duplicate( server );
    }

    public static function getServerProductInfo() {
        var cfProductName = static.serverScope.ColdFusion.ProductName;

        if (cfProductName.contains("Lucee")) {
            return {
                "cfServer": "Lucee",
                "serverVersion": static.serverScope.lucee.version,
                "serverMainVersion": static.serverScope.lucee.version.listFirst(".")
            };
        } else if (cfProductName.contains("ColdFusion")) {
            return {
                "cfServer": "ACF",
                "serverVersion": static.serverScope.coldfusion.productversion,
                "serverMainVersion": static.serverScope.coldfusion.productversion.listFirst(),
                "productLevel": static.serverScope.coldfusion.productlevel
            };
        } else if (static.serverScope.keyExists("boxlang")) {
            return {
                "cfServer": "Boxlang",
                "serverVersion": static.serverScope.boxlang.version,
                "serverMainVersion": static.serverScope.boxlang.version.listFirst(".")
            };
        } else {
            return {
                "cfServer": "",
                "serverVersion": ""
            };
        }
    }

}
