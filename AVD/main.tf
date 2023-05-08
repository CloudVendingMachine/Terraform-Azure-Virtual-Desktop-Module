resource "azurecaf_name" "workspace" {
  name            = var.workspace_name
  resource_type   = "azurerm_virtual_desktop_workspace"
  suffixes        = [var.company_short_name, var.environment_short_name]
}

# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = azurecaf_name.workspace.result
  resource_group_name = var.rg_name
  location            = var.location
  friendly_name       = "${var.workspace_name} Workspace"
  description         = "${var.workspace_name} Workspace"
}

resource "azurecaf_name" "hostpool" {
  name            = var.workspace_name
  resource_type   = "azurerm_virtual_desktop_host_pool"
  suffixes        = [var.company_short_name, var.environment_short_name]
}
# Create AVD host pool
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  resource_group_name = var.rg_name
  location            = var.location
  name                     = azurecaf_name.hostpool.result
  friendly_name            = "avd host pool"
  validate_environment     = true
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = "avd Terraform HostPool"
  type                     = "Pooled"
  maximum_sessions_allowed = 16
  load_balancer_type       = "DepthFirst" #[BreadthFirst DepthFirst]
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = var.rfc3339
}

resource "azurecaf_name" "dag" {
  name            = var.workspace_name
  resource_type   = "azurerm_virtual_desktop_application_group"
  suffixes        = [var.company_short_name, var.environment_short_name]
}

# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = var.rg_name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  location            = var.location
  type                = "Desktop"
  name                = azurecaf_name.dag.result
  friendly_name       = "Desktop AppGroup"
  description         = "AVD application group"
  depends_on          = [azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_workspace.workspace]
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}

############################sessionhost##########################

locals {
  registration_token = azurerm_virtual_desktop_host_pool_registration_info.registrationinfo.token
}

resource "random_string" "AVD_local_password" {
  count            = var.rdsh_count
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

data "azurerm_virtual_network" "ad_vnet_data" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "ad_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
} 

resource "azurecaf_name" "nic" {
  name            = var.vm_name
  resource_type   = "azurerm_network_interface"
  suffixes        = [var.company_short_name, var.environment_short_name]
}

resource "azurerm_network_interface" "avd_vm_nic" {
  count               = var.rdsh_count
  name                = "${azurecaf_name.nic.result}-${count.index}"
  resource_group_name = var.rg_name
  location            = var.location

  ip_configuration {
    name                          = "nic${count.index + 1}_config"
    subnet_id                     = data.azurerm_subnet.ad_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurecaf_name" "vm" {
  name            = var.vm_name
  resource_type   = "azurerm_windows_virtual_machine"
  suffixes        = [var.company_short_name, var.environment_short_name]
}

resource "azurecaf_name" "os_disk" {
  name            = var.vm_name
  resource_type   = "azurerm_managed_disk"
  suffixes        = [var.company_short_name, var.environment_short_name]
}

resource "azurerm_windows_virtual_machine" "avd_vm" {
  count                 = var.rdsh_count
  name                  = "${azurecaf_name.vm.result}-${count.index}"
  resource_group_name = var.rg_name
  location            = var.location
  size                  = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.avd_vm_nic.*.id[count.index]}"]
  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = var.local_admin_password

  os_disk {
    name                 = "${azurecaf_name.os_disk.result}-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h2-evd"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.avd_vm_nic
  ]
}

resource "azurecaf_name" "vmext1" {
  name            = var.vm_name
  resource_type   = "azurerm_virtual_machine_extension"
  suffixes        = [var.company_short_name, var.environment_short_name]
}

resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  count                      = var.rdsh_count
  name                       = "${azurecaf_name.vmext1.result}-${var.workspace_name}-${count.index}"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.hostpool.name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${local.registration_token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    
    azurerm_virtual_desktop_host_pool.hostpool,
    azurerm_virtual_machine_extension.domain_join
  ]
}

resource "azurecaf_name" "vmext2" {
  name            = var.vm_name
  resource_type   = "azurerm_virtual_machine_extension"
  suffixes        = [var.company_short_name, var.environment_short_name]
}

resource "azurerm_virtual_machine_extension" "domain_join" {
  count                      = var.rdsh_count
  name                       = azurecaf_name.vmext2.result
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "Name": "${var.domain_name}",
      "OUPath": "${var.ou_path}",
      "User": "${var.domain_user_upn}",
      "Restart": "true",
      "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domain_password}"
    }
PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

}


