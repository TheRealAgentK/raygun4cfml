component {

    /**
     * Checks if current CFML engine is Lucee
     */
    public static boolean function isLucee() {
        var serverInfo = ProductCheck::getServerProductInfo();
        return !serverInfo.isEmpty() && serverInfo["cfServer"] == "Lucee";
    }

    /**
     * Checks if current CFML engine is Adobe ColdFusion 2021
     */  
    public static boolean function isACF2021() {
        var serverInfo = ProductCheck::getServerProductInfo();
        return !serverInfo.isEmpty() && serverInfo["cfServer"] == "ACF" && serverInfo["serverMainVersion"] == "2021";
    }

}
