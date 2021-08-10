/**
Copyright 2021 Kai Koenig, Ventego Creative Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

component {

    package struct function getServerProductInfo() {
      
        var productInfo = {};

        if (server.ColdFusion.ProductName CONTAINS "Railo") {
                productInfo.cf_server = "Railo";
                productInfo.server_version = listFirst(server.railo.version);
        } else if (server.ColdFusion.ProductName CONTAINS "Lucee") {
                productInfo.cf_server = "Lucee";
                productInfo.server_version = listFirst(server.lucee.version);
        } else if (server.ColdFusion.ProductName CONTAINS "ColdFusion") {
                productInfo.cf_server = "ACF";
                productInfo.server_version = server.coldfusion.productversion;
                productInfo.server_main_version = ListFirst(productInfo.server_version);
                productInfo.product_level = server.coldfusion.productlevel;
        }

        return productInfo;
    }

}
