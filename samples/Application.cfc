component {

    this.mappings = {
        "/nz" = expandPath("/src/nz"),
        "/com" = expandPath("/src/com")
    };

    public void function onRequestStart() {
        variables.RAYGUNAPIKEY = "V84wUYVR5lWGHgVMq5Cxig";
    }

}
