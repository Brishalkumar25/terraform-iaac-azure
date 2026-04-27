resource "azurerm_public_ip" "pip_appgw" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  idle_timeout_in_minutes = 4
  ip_version              = "IPv4"
  location                = var.location
  name                    = "pip-app-gw"
  resource_group_name     = var.resourceGroupName
  sku                     = "Standard"
  sku_tier                = "Regional"
  zones                   = ["1", "2", "3"]
}

resource "azurerm_web_application_firewall_policy" "waf_policy" {
  name                = "waf-policy"
  location            = var.location
  resource_group_name = var.resourceGroupName

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw"
  location            = var.location
  resource_group_name = var.resourceGroupName

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip"
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.pip_appgw.id
  }

  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "public-ip"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    ssl_certificate_name           = "ssl-cert"
  }

  backend_address_pool {
    name = "backend-pool"

    ip_addresses = [azurerm_network_interface.nic.private_ip_address, azurerm_network_interface.nic2.private_ip_address]
    

  }

  backend_http_settings {
    name                  = "http-settings"
    protocol              = "Http"
    port                  = 80
    request_timeout       = 30
    cookie_based_affinity = "Disabled"
    probe_name            = "http-probe"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 1
  }

  probe {
    name                = var.appgw_probe.name
    protocol            = var.appgw_probe.protocol
    path                = var.appgw_probe.path
    interval            = var.appgw_probe.interval
    timeout             = var.appgw_probe.timeout
    unhealthy_threshold = var.appgw_probe.unhealthy_threshold
    host                = var.appgw_probe.host
  }




  ssl_certificate {
    name                = "ssl-cert"
    key_vault_secret_id = data.azurerm_key_vault_certificate.cert.secret_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.umi.id]
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.waf_policy.id
}
