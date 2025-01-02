component extends="samples.Application" {

    public void function onRequestStart() {
        super.onRequestStart();
    }

    public void function onError(required any exception, required string eventName) {
        var customUserDataRaw = {
            "session": {
                "memberID": "5747854",
                "memberFirstName": "Kai"
            },
            "params": {
                "currentAction": "IwasDoingThis",
                "justAnotherParam": "test"
            }
        };
        var customUserData = new com.raygun.user.RaygunUserCustomData()
            .setUserCustomData(customUserDataRaw);

        var tags = ["onError", "unfiltered", "unhandled exception"];
           
        var userIdentifier = new com.raygun.message.RaygunIdentifierMessage()
            .setIdentifier("test@test.com")
            .setIsAnonymous(false)
            .setUuid("47e432fff11")
            .setFirstName("Test")
            .setFullName("Tester");

        var settings = new com.raygun.environment.RaygunSettings()
            .setRawDataMaxLength( 10000 );

        var raygun = new com.raygun.RaygunClient(
            apiKey = variables.RAYGUNAPIKEY,
            appVersion = "4.3.6",
            settings = settings
        );

        var result = raygun.send(
            issueData = arguments.exception,
            userCustomData = customUserData,
            tags = tags,
            user = userIdentifier
        );
    }

}
