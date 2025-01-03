component accessors="true" {

    property name="userCustomData" type="struct";

    public RaygunUserCustomData function init( struct userCustomData = {} ) {
        setUserCustomData( userCustomData );
        return this;
    }

    public function build() {
        return getUserCustomData();
    }

}
