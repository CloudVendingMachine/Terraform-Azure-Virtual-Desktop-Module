# Azure-Virtual-Desktop
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.dag](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.hostpool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.nic](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.os_disk](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.vm](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.vmext1](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.vmext2](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.workspace](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_network_interface.avd_vm_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_desktop_application_group.dag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) | resource |
| [azurerm_virtual_desktop_host_pool.hostpool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) | resource |
| [azurerm_virtual_desktop_host_pool_registration_info.registrationinfo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool_registration_info) | resource |
| [azurerm_virtual_desktop_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace) | resource |
| [azurerm_virtual_desktop_workspace_application_group_association.ws-dag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) | resource |
| [azurerm_virtual_machine_extension.domain_join](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.vmext_dsc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.avd_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_string.AVD_local_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_subnet.ad_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.ad_vnet_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_company_short_name"></a> [company\_short\_name](#input\_company\_short\_name) | variable "environment" {} | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Name of the domain to join | `string` | n/a | yes |
| <a name="input_domain_password"></a> [domain\_password](#input\_domain\_password) | Password of the user to authenticate with the domain | `string` | n/a | yes |
| <a name="input_domain_user_upn"></a> [domain\_user\_upn](#input\_domain\_user\_upn) | Username for domain join (do not include domain name as this is appended) | `string` | n/a | yes |
| <a name="input_environment_short_name"></a> [environment\_short\_name](#input\_environment\_short\_name) | n/a | `string` | n/a | yes |
| <a name="input_local_admin_password"></a> [local\_admin\_password](#input\_local\_admin\_password) | local admin password | `string` | n/a | yes |
| <a name="input_local_admin_username"></a> [local\_admin\_username](#input\_local\_admin\_username) | local admin username | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the resource group. | `string` | n/a | yes |
| <a name="input_ou_path"></a> [ou\_path](#input\_ou\_path) | n/a | `string` | `""` | no |
| <a name="input_rdsh_count"></a> [rdsh\_count](#input\_rdsh\_count) | Number of AVD machines to deploy | `number` | n/a | yes |
| <a name="input_rfc3339"></a> [rfc3339](#input\_rfc3339) | Registration token expiration | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Name of the Resource group in which to deploy service objects | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | subnet name | `string` | n/a | yes |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | caf Name of the azure virtual machine | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Size of the machine to deploy | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of domain controller vnet | `string` | n/a | yes |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | caf Name of the Azure Virtual Desktop workspace | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_virtual_desktop_host_pool"></a> [azure\_virtual\_desktop\_host\_pool](#output\_azure\_virtual\_desktop\_host\_pool) | Name of the Azure Virtual Desktop host pool |
| <a name="output_azurerm_virtual_desktop_application_group"></a> [azurerm\_virtual\_desktop\_application\_group](#output\_azurerm\_virtual\_desktop\_application\_group) | Name of the Azure Virtual Desktop DAG |
| <a name="output_azurerm_virtual_desktop_workspace"></a> [azurerm\_virtual\_desktop\_workspace](#output\_azurerm\_virtual\_desktop\_workspace) | Name of the Azure Virtual Desktop workspace |
