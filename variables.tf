# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# variables.tf 
#
# Purpose: The following file declares all variables used in this backend repository

/********** Provider Variables NOT OVERLOADABLE **********/
variable "region" {
  description = "Target region where artifacts are going to be created"
}

variable "tenancy_ocid" {
  description = "OCID of tenancy"
}

variable "user_ocid" {
  description = "User OCID in tenancy. Currently hardcoded to user denny.alquinta@oracle.com"
}

variable "fingerprint" {
  description = "API Key Fingerprint for user_ocid derived from public API Key imported in OCI User config"
}

variable "private_key_path" {
  description = "Private Key Absolute path location where terraform is executed"

}
/********** Provider Variables NOT OVERLOADABLE **********/

/********** Brick Variables **********/

/********** FSS Variables **********/

variable "fss_mount_target_name" {
  description = "User friendly name for Mount Target"
}

variable "fss_display_name_base" {
  description = "User friendly name for File Storage Service"
}

variable "export_path_base" {
  description = "Export path for File Storage Service"
}
variable "mt_compartment_name" {
  description = "Mount Target Compartment Location"
  default     = ""
}
variable "mt_compartment_id" {
  description = "Mount Target Compartment Location OCID"
  default     = ""
}

variable "label_zs" {
  type    = list(any)
  default = ["0", ""]
}

variable "num_of_fss" {
  description = "Amount of FSS that will be created"
}

variable "fss_mount_target_availability_domain" {
  description = "Availability domain where the mount target is located at"

}

variable "os_type" {
  description = "Describes the type of OS currently in place. Valid values are: linux, ubuntu, windows"
  type        = string


}

variable "ssh_private_is_path" {
  description = "Determines if key is supposed to be on file or in text"
  default     = true
}

variable "ssh_private_key" {
  description = "Determines what is the private key to connect to machine"
  default = ""
}

variable "compute_private_ip" {
  description = "Compute private IP to logon into machine"
}

variable "compute_display_name" {
  description = "Describes the compute display name to which the disks will be associated with"
  default = ""
  
}

variable "win_os_password" {
description = "Windows Server OS Password"
default = ""
  
}

variable "disk_unit" {
description = "Disk Unit Assigned to NFS Disk"
default = ""
  
}

variable "is_winrm_configured_for_image" {
  description = "Defines if winrm is being used in this installation"
  type = bool
  default     = true
}


variable "is_winrm_configured_with_ssl" {
  description = "Use the https 5986 port for winrm by default. If that fails with a http response error: 401 - invalid content type, the SSL may not be configured correctly"
  type = bool
  default     = true
}
/********** FSS Variables **********/

/********** Datasource and Subnet Lookup related variables **********/

variable "fss_instance_compartment_name" {
  description = "Defines the compartment name where the infrastructure will be created"
  default     = ""
}

variable "fss_instance_compartment_id" {
  description = "Defines the compartment OCID where the infrastructure will be created"
  default     = ""
}

variable "fss_network_compartment_name" {
  description = "Defines the compartment where the Network is currently located"
}

variable "vcn_display_name" {
  description = "Display Name associated to VCN"
}

variable "network_subnet_name" {
  description = "Name of the subnet where the artifact is located"
}

/********** Datasource related variables **********/

/********** Brick Variables **********/