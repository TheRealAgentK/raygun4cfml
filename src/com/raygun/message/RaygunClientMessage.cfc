component {

    public RaygunClientMessage function init() {
        return this;
    }

    public struct function build() {
        var returnContent = {
            "name"      : com.raygun.environment.RaygunConfig::getRaygunClientName(),
            "version"   : com.raygun.environment.RaygunConfig::getRaygunClientVersion(),
            "clientUrl" : com.raygun.environment.RaygunConfig::getRaygunClientUrl()
        };

        return returnContent;
    }

}
