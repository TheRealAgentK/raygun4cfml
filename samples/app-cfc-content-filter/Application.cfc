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
            .userCustomData(customUserDataRaw);

        var tags = ["onError", "filtered", "unhandled exception"];
        
        var userIdentifier = new com.raygun.message.RaygunIdentifierMessage()
            .identifier("test@test.com")
            .isAnonymous(false)
            .uuid("47e432fff11")
            .firstName("Test")
            .fullName("Tester");

        var filterRaw = [{filter = "password", replacement = "__password__"}, {filter = "creditcard", replacement = "__ccnumber__"}];
        var contentFilter = new com.raygun.filter.RaygunContentFilter()
            .filter(filterRaw);
            
        var raygun = new "nz.co.ventego-creative.raygun4cfml.RaygunClient"(
            apiKey = variables.RAYGUNAPIKEY,
            appVersion = "4.3.6",
            contentFilter = contentFilter
        );

        var result = raygun.send(
            issueData = arguments.exception,
            userCustomData = customUserData,
            tags = tags,
            user = userIdentifier
        );
    }

}
