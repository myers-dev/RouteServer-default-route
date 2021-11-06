location = "eastus"

resource_group_name = "RS"

tags = {
    Terraform   = "true"
    Environment = "dev"
} 
    
lock_level = ""

security_group_name = "nsg"

custom_rules = [
  {
    name                   = "ssh1"
    priority               = 200
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "tcp"
    source_port_range      = "*"
    destination_port_range = "22"
    source_address_prefix  = "67.85.28.42/32"
    description            = "description-myssh"
  },
  {
    name                    = "http1"
    priority                = 201
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "tcp"
    source_port_range       = "*"
    destination_port_range  = "8080"
    source_address_prefixes = ["67.85.28.42/32"]
    description             = "description-http"
  },
  {
    name                   = "ssh2"
    priority               = 202
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "tcp"
    source_port_range      = "*"
    destination_port_range = "22"
    source_address_prefix  = "68.198.27.197/32"
    description            = "description-myssh"
  },
  {
    name                    = "http2"
    priority                = 203
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "tcp"
    source_port_range       = "*"
    destination_port_range  = "8080"
    source_address_prefixes = ["68.198.27.197/32"]
    description             = "description-http"
  }
]

vnets = [   
          { 
            name = "hub"
            address_space = ["10.1.0.0/16"]
            subnet_names = [ "RouteServerSubnet" , "default" ]
            subnet_prefixes = [ "10.1.0.0/24" , "10.1.1.0/24" ]
            enforce_private_link_endpoint_network_policies = { 
              default = true # "privateEndpointNetworkPolicies": "Disabled=true Enabled=false",
              RouteServerSubnet = true # "privateEndpointNetworkPolicies": "Disabled=true Enabled=false",
              }
            enforce_private_link_service_network_policies = {
              default = true # "privateLinkServiceNetworkPolicies": "Disabled=true Enabled=false",
              RouteServerSubnet = true # "privateLinkServiceNetworkPolicies": "Disabled=true Enabled=false",
              }
            },
            {
            name = "spoke"
            address_space = ["10.0.0.0/16"]
            subnet_names = [  "pe", "default" ]
            subnet_prefixes = [ "10.0.1.0/24", "10.0.0.0/24" ]
            enforce_private_link_endpoint_network_policies = {
              default = true # "privateEndpointNetworkPolicies": "Disabled=true Enabled=false",
              pe = true 
              }
            enforce_private_link_service_network_policies = {
              default = true # "privateLinkServiceNetworkPolicies": "Disabled=true Enabled=false",
              pe = true 
              }
            },
            {
            name = "remote"
            address_space = ["10.2.0.0/16"]
            subnet_names = [  "GatewaySubnet","default" ]
            subnet_prefixes = ["10.2.0.0/24", "10.2.1.0/24" ]
            enforce_private_link_endpoint_network_policies = {
              default = true # "privateEndpointNetworkPolicies": "Disabled=true Enabled=false",
              GatewaySubnet = true
              }
            enforce_private_link_service_network_policies = {
              default = true # "privateLinkServiceNetworkPolicies": "Disabled=true Enabled=false",
              GatewaySubnet = true
              }
            }
        ]            
 
csr_scale = 1




