component {

    public RaygunEnvironmentMessage function init() {
        return this;
    }

    public struct function build() {
        var returnContent = {};
        var runtime       = createObject( "java", "java.lang.System" );
        var props         = runtime.getProperties();
        var mf            = createObject(
            "java",
            "java.lang.management.ManagementFactory"
        );
        var heapMem = "";
        var osbean  = "";

        returnContent[ "architecture" ]   = props[ "os.arch" ];
        returnContent[ "osVersion" ]      = props[ "os.version" ];
        returnContent[ "packageVersion" ] = props[ "java.vm.vendor" ] & " | " & props[ "java.runtime.version" ] & " | " & props[
            "java.vm.name"
        ];
        returnContent[ "platform" ] = props[ "os.name" ];

        try {
            heapMem                                   = mf.getMemoryMXBean().getHeapMemoryUsage();
            returnContent[ "availableVirtualMemory" ] = heapMem.getCommitted() - heapMem.getUsed();
            returnContent[ "totalVirtualMemory" ]     = heapMem.getCommitted();
        } catch ( any e ) {
            returnContent[ "availableVirtualMemory" ] = javacast( "null", "" );
            returnContent[ "totalVirtualMemory" ]     = javacast( "null", "" );
        }

        try {
            osbean                                     = mf.getOperatingSystemMXBean();
            returnContent[ "availablePhysicalMemory" ] = osbean.getFreePhysicalMemorySize();
            returnContent[ "totalPhysicalMemory" ]     = osbean.getTotalPhysicalMemorySize();
        } catch ( any e ) {
            returnContent[ "availablePhysicalMemory" ] = javacast( "null", "" );
            returnContent[ "totalPhysicalMemory" ]     = javacast( "null", "" );
        }

        return returnContent;
    }

}
