component {

    public RaygunClientMessage function init() {
        return this;
    }

    public struct function build() {
        var returnContent = {
            "name"      : com.raygun.environment.RaygunConfig::RAYGUN_CLIENT_NAME,
            "version"   : com.raygun.environment.RaygunConfig::RAYGUN_CLIENT_VERSION,
            "clientUrl" : com.raygun.environment.RaygunConfig::RAYGUN_CLIENT_URL
        };

        return returnContent;
    }

}
