# OCI Cloud Bricks: File System Service (FSS)

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-cloudbricks-fss)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-cloudbricks-fss)

## Introduction
The following cloud brick enables you to create batches of File Storage Services starting to 1 to many associated to a specific subnet and mount target within a compartment

## Reference Architecture
The following is the reference architecture associated to this brick

![Reference Architecture](./images/Bricks_Architectures-File_Storage_Service.jpeg)

### Prerequisites
- A pre-existent VCN
- A pre-existent Mount Target
- A pre existent Compartment Structure

---
## Sample tfvar file
If wanting to provision FSS on its own

```shell
########## SAMPLE TFVAR FILE ##########
########## PROVIDER SPECIFIC VARIABLES ##########
region           = "foo-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..abcdefg"
user_ocid        = "ocid1.user.oc1..aaaaaaabcdefg"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
########## PROVIDER SPECIFIC VARIABLES ##########

########## ARTIFACT SPECIFIC VARIABLES ##########
num_of_fss                           = 3
fss_disk_group_base                  = "test-fss"
export_path_base                     = "/fss"
fss_disk_name_base                   = "fssdisk"
fss_instance_compartment_name        = "MY_FSS_COMPARTMENT"
fss_network_compartment_name         = "MY_NETWORK_COMPARTMENT"
mt_compartment_name                  = "MY_MOUNT_TARGET_COMPARTMENT"
vcn_display_name                     = "MY_VCN"
network_subnet_name                  = "MY_PRIVATE_SUBNET"
fss_mount_target_availability_domain = "abcd:RE-REGION-1-AD-1"
fss_mount_target_name                = "MY_MOUNT_TARGET_NAME"
########## ARTIFACT SPECIFIC VARIABLES ##########
########## SAMPLE TFVAR FILE ##########
```

If attaching fss to Oracle Linux
```shell
########## SAMPLE TFVAR FILE ##########
########## PROVIDER SPECIFIC VARIABLES ##########
region           = "foo-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..abcdefg"
user_ocid        = "ocid1.user.oc1..aaaaaaabcdefg"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
########## PROVIDER SPECIFIC VARIABLES ##########

########## ARTIFACT SPECIFIC VARIABLES ##########
num_of_fss                           = 3
fss_disk_group_base                  = "test-fss"
export_path_base                     = "/fss"
fss_disk_name_base                   = "fssdisk"
fss_instance_compartment_name        = "MY_FSS_COMPARTMENT"
fss_network_compartment_name         = "MY_NETWORK_COMPARTMENT"
mt_compartment_name                  = "MY_MOUNT_TARGET_COMPARTMENT"
vcn_display_name                     = "MY_VCN"
network_subnet_name                  = "MY_PRIVATE_SUBNET"
fss_mount_target_availability_domain = "abcd:RE-REGION-1-AD-1"
fss_mount_target_name                = "MY_MOUNT_TARGET_NAME"

compute_private_ips = ["10.0.0.1"]
os_type             = "linux"
ssh_private_key     = "/path/to/my/ssh/key"
########## ARTIFACT SPECIFIC VARIABLES ##########
########## SAMPLE TFVAR FILE ##########
```

If attaching fss to Ubuntu
```shell
########## SAMPLE TFVAR FILE ##########
########## PROVIDER SPECIFIC VARIABLES ##########
region           = "foo-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..abcdefg"
user_ocid        = "ocid1.user.oc1..aaaaaaabcdefg"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
########## PROVIDER SPECIFIC VARIABLES ##########

########## ARTIFACT SPECIFIC VARIABLES ##########
num_of_fss                           = 3
fss_disk_group_base                  = "test-fss"
export_path_base                     = "/fss"
fss_disk_name_base                   = "fssdisk"
fss_instance_compartment_name        = "MY_FSS_COMPARTMENT"
fss_network_compartment_name         = "MY_NETWORK_COMPARTMENT"
mt_compartment_name                  = "MY_MOUNT_TARGET_COMPARTMENT"
vcn_display_name                     = "MY_VCN"
network_subnet_name                  = "MY_PRIVATE_SUBNET"
fss_mount_target_availability_domain = "abcd:RE-REGION-1-AD-1"
fss_mount_target_name                = "MY_MOUNT_TARGET_NAME"

compute_private_ips = ["10.0.0.1"]
os_type             = "ubuntu"
ssh_private_key     = "/path/to/my/ssh/key"
########## ARTIFACT SPECIFIC VARIABLES ##########
########## SAMPLE TFVAR FILE ##########
```

If attaching fss to Windows
- **Be aware that you may need to restart Windows instances after mounting FSS for them to show up.**
```shell
########## SAMPLE TFVAR FILE ##########
########## PROVIDER SPECIFIC VARIABLES ##########
region           = "foo-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..abcdefg"
user_ocid        = "ocid1.user.oc1..aaaaaaabcdefg"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
########## PROVIDER SPECIFIC VARIABLES ##########

########## ARTIFACT SPECIFIC VARIABLES ##########
num_of_fss                           = 3
fss_disk_group_base                  = "test-fss"
export_path_base                     = "/fss"
fss_disk_name_base                   = "fssdisk"
fss_instance_compartment_name        = "MY_FSS_COMPARTMENT"
fss_network_compartment_name         = "MY_NETWORK_COMPARTMENT"
mt_compartment_name                  = "MY_MOUNT_TARGET_COMPARTMENT"
vcn_display_name                     = "MY_VCN"
network_subnet_name                  = "MY_PRIVATE_SUBNET"
fss_mount_target_availability_domain = "abcd:RE-REGION-1-AD-1"
fss_mount_target_name                = "MY_MOUNT_TARGET_NAME"

compute_private_ips = ["10.0.0.1"]
os_type             = "windows"
win_os_password     = "MY_WINDOWS_PASSWORD"
########## ARTIFACT SPECIFIC VARIABLES ##########
########## SAMPLE TFVAR FILE ##########
```

### Variable specific considerations
- When variable `num_of_fss` is greater than 1, there is a chance that the following error appears:

```shell
Error: 409-Conflict 
 Provider version: 4.40.0, released on 2021-08-18.  
 Service: File Storage System 
 Error Message: Another filesystem is currently being provisioned, try again later 
 OPC request ID: 08cdbcfa22bd1618f7c59b6c784c574d/D0703FEC7507DB939448D64253BBC0F8/AA11BA35A2B6FE2F2B18A25F4BEDF26C 
 Suggestion: The resource is in a conflicted state. Please retry again or contact support for help with service: File Storage System
 
 
   with oci_file_storage_file_system.FileStorage[5],
   on fss.tf line 2, in resource "oci_file_storage_file_system" "FileStorage":
    2: resource "oci_file_storage_file_system" "FileStorage" {
  
```  
- If this occurs, be sure to handle a retry logic on code that executes this module at least `num_of_fss + 1` times

- Variables `fss_disk_group_base`, `export_path_base` and `fss_disk_name_base` make up the display names and export paths for the FSS. See the example below on how these show up in OCI:
```shell
fss_disk_group_base = "test-fss"
export_path_base    = "/fss"
fss_disk_name_base  = "fssdisk"

> export_path: /test-fss/fss01, /test-fss/fss02..
> display_name: test-fss_fssdisk01, test-fss_fssdisk02..
```

- Variable `compute_private_ips` is a list of the IPs of the instances that will be used to mount the FSS.

## Sample provider
The following is the base provider definition to be used with this module

```shell
terraform {
  required_version = ">= 0.13.5"
}
provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  disable_auto_retries = "true"
}

provider "oci" {
  alias        = "home"
  region       = data.oci_identity_region_subscriptions.home_region_subscriptions.region_subscriptions[0].region_name
  tenancy_ocid = var.tenancy_ocid  
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  disable_auto_retries = "true"
}
```

---
## Variable documentation

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | 4.77.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.install_prereq_linux_os](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.install_prereq_ubuntu_os](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.install_prereq_windows_os](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.mount_disk_linux](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.mount_disk_ubuntu](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.mount_disk_windows](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [oci_file_storage_export.ExportFileSystemMount](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/file_storage_export) | resource |
| [oci_file_storage_file_system.FileStorage](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/file_storage_file_system) | resource |
| [oci_core_private_ip.MOUNTPRIVATEIP](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_private_ip) | data source |
| [oci_core_subnets.SUBNET](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_subnets) | data source |
| [oci_core_vcns.VCN](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_vcns) | data source |
| [oci_file_storage_mount_targets.MOUNTTARGET](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/file_storage_mount_targets) | data source |
| [oci_identity_compartments.COMPARTMENTS](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_compartments) | data source |
| [oci_identity_compartments.MTCOMPARTMENTS](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_compartments) | data source |
| [oci_identity_compartments.NWCOMPARTMENTS](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_compartments) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compute_private_ips"></a> [compute\_private\_ips](#input\_compute\_private\_ips) | Compute private IPs to logon into machine | `string` | `""` | no |
| <a name="input_export_path_base"></a> [export\_path\_base](#input\_export\_path\_base) | Export path for File Storage Service | `any` | n/a | yes |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | API Key Fingerprint for user\_ocid derived from public API Key imported in OCI User config | `any` | n/a | yes |
| <a name="input_fss_disk_group_base"></a> [fss\_disk\_group\_base](#input\_fss\_disk\_group\_base) | Describes the group display name to which the disks will be associated with | `string` | `""` | no |
| <a name="input_fss_disk_name_base"></a> [fss\_disk\_name\_base](#input\_fss\_disk\_name\_base) | User friendly name for File Storage Service | `any` | n/a | yes |
| <a name="input_fss_instance_compartment_id"></a> [fss\_instance\_compartment\_id](#input\_fss\_instance\_compartment\_id) | Defines the compartment OCID where the infrastructure will be created | `string` | `""` | no |
| <a name="input_fss_instance_compartment_name"></a> [fss\_instance\_compartment\_name](#input\_fss\_instance\_compartment\_name) | Defines the compartment name where the infrastructure will be created | `string` | `""` | no |
| <a name="input_fss_mount_target_availability_domain"></a> [fss\_mount\_target\_availability\_domain](#input\_fss\_mount\_target\_availability\_domain) | Availability domain where the mount target is located at | `any` | n/a | yes |
| <a name="input_fss_mount_target_name"></a> [fss\_mount\_target\_name](#input\_fss\_mount\_target\_name) | User friendly name for Mount Target | `any` | n/a | yes |
| <a name="input_fss_network_compartment_name"></a> [fss\_network\_compartment\_name](#input\_fss\_network\_compartment\_name) | Defines the compartment where the Network is currently located | `any` | n/a | yes |
| <a name="input_is_winrm_configured_for_image"></a> [is\_winrm\_configured\_for\_image](#input\_is\_winrm\_configured\_for\_image) | Defines if winrm is being used in this installation | `bool` | `true` | no |
| <a name="input_is_winrm_configured_with_ssl"></a> [is\_winrm\_configured\_with\_ssl](#input\_is\_winrm\_configured\_with\_ssl) | Use the https 5986 port for winrm by default. If that fails with a http response error: 401 - invalid content type, the SSL may not be configured correctly | `bool` | `true` | no |
| <a name="input_label_zs"></a> [label\_zs](#input\_label\_zs) | n/a | `list(any)` | <pre>[<br>  "0",<br>  ""<br>]</pre> | no |
| <a name="input_mt_compartment_id"></a> [mt\_compartment\_id](#input\_mt\_compartment\_id) | Mount Target Compartment Location OCID | `string` | `""` | no |
| <a name="input_mt_compartment_name"></a> [mt\_compartment\_name](#input\_mt\_compartment\_name) | Mount Target Compartment Location | `string` | `""` | no |
| <a name="input_network_subnet_name"></a> [network\_subnet\_name](#input\_network\_subnet\_name) | Name of the subnet where the artifact is located | `any` | n/a | yes |
| <a name="input_num_of_fss"></a> [num\_of\_fss](#input\_num\_of\_fss) | Amount of FSS that will be created | `any` | n/a | yes |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Describes the type of OS currently in place. Valid values are: linux, ubuntu, windows | `string` | `""` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Private Key Absolute path location where terraform is executed | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Target region where artifacts are going to be created | `any` | n/a | yes |
| <a name="input_ssh_private_is_path"></a> [ssh\_private\_is\_path](#input\_ssh\_private\_is\_path) | Determines if key is supposed to be on file or in text | `bool` | `true` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Determines what is the private key to connect to machine | `string` | `""` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCID of tenancy | `any` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | User OCID in tenancy. Currently hardcoded to user denny.alquinta@oracle.com | `any` | n/a | yes |
| <a name="input_vcn_display_name"></a> [vcn\_display\_name](#input\_vcn\_display\_name) | Display Name associated to VCN | `any` | n/a | yes |
| <a name="input_win_os_password"></a> [win\_os\_password](#input\_win\_os\_password) | Windows Server OS Password | `string` | `""` | no |
| <a name="input_windows_drive_letters"></a> [windows\_drive\_letters](#input\_windows\_drive\_letters) | n/a | `list(any)` | <pre>[<br>  "Z",<br>  "Y",<br>  "X",<br>  "W",<br>  "V",<br>  "U",<br>  "T",<br>  "S",<br>  "R",<br>  "Q",<br>  "P",<br>  "O",<br>  "N",<br>  "M",<br>  "L",<br>  "K",<br>  "J",<br>  "I",<br>  "H",<br>  "G",<br>  "F",<br>  "E",<br>  "D"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_FSS"></a> [FSS](#output\_FSS) | FSS Object |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | Display Name of FSS |
| <a name="output_export_path_base"></a> [export\_path\_base](#output\_export\_path\_base) | Export path of FSS |
| <a name="output_mount_target_private_ip"></a> [mount\_target\_private\_ip](#output\_mount\_target\_private\_ip) | Private IP of Mount Target |


## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2021 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.
