component accessors="true" {

    property name="identifier"  type="string"  default="";
    property name="isAnonymous" type="boolean" default="";
    property name="email"       type="string"  default="";
    property name="fullName"    type="string"  default="";
    property name="firstName"   type="string"  default="";
    property name="uuid"        type="string"  default="";

    public RaygunIdentifierMessage function init(
        string identifier   = "",
        boolean isAnonymous = true,
        string email        = "",
        string fullName     = "",
        string firstName    = "",
        string uuid         = ""
    ) {
        setIdentifier( identifier );
        setIsAnonymous( isAnonymous );
        setEmail( email );
        setFullName( fullName );
        setFirstName( firstName );
        setUuid( uuid );
        return this;
    }

    public struct function build() {
        return {
            "identifier"  : getIdentifier(),
            "isAnonymous" : getIsAnonymous(),
            "email"       : getEmail(),
            "fullName"    : getFullName(),
            "firstName"   : getFirstName(),
            "uuid"        : getUuid()
        };
    }

}
