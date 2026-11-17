# Control plane identity: ours, so we can grant it rights on the subnet before the cluster exists (D19)
resource "azurerm_user_assigned_identity" "control_plane" {
  name                = "id-${var.name_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_role_assignment" "control_plane_network" {
  scope                = var.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.control_plane.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.name_prefix}"
  kubernetes_version  = var.kubernetes_version
  sku_tier            = "Free" # D13
  tags                = var.tags

  oidc_issuer_enabled       = true # issuer for workload identity federation (D22)
  workload_identity_enabled = true # installs the mutating webhook
  local_account_disabled    = true # no static admin kubeconfig: Entra ID only (D20)

  azure_active_directory_role_based_access_control {
    tenant_id          = var.tenant_id
    azure_rbac_enabled = true # Kubernetes permissions through Azure roles
  }

  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_ranges
  }

  default_node_pool {
    name                        = "system"
    vm_size                     = var.node_vm_size
    node_count                  = var.node_count
    os_disk_size_gb             = var.os_disk_size_gb # P6 instead of the default 128 GB (D30)
    vnet_subnet_id              = var.subnet_id
    temporary_name_for_rotation = "systemtmp" # lets a vm_size change rotate the pool instead of failing

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.control_plane.id]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay" # pods get IPs from pod_cidr, not from the subnet (D15)
    network_data_plane  = "cilium"
    network_policy      = "cilium"
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr # must not overlap the VNet (D16)
    dns_service_ip      = var.dns_service_ip
    outbound_type       = "loadBalancer" # D17
    load_balancer_sku   = "standard"
  }

  depends_on = [azurerm_role_assignment.control_plane_network]
}