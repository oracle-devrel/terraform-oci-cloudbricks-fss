# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# datasource.tf
#
# Purpose: The following script defines the lookup logic used in code to obtain pre-created or JIT-created resources in tenancy.


/********** Compartment and CF Accessors **********/
data "oci_identity_compartments" "COMPARTMENTS" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.fss_instance_compartment_name]
  }
}

data "oci_identity_compartments" "NWCOMPARTMENTS" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.fss_network_compartment_name]
  }
}

data "oci_core_vcns" "VCN" {
  compartment_id = local.nw_compartment_id
  filter {
    name   = "display_name"
    values = [var.vcn_display_name]
  }
}


/********** Subnet Accessors **********/

data "oci_core_subnets" "SUBNET" {
  compartment_id = local.nw_compartment_id
  vcn_id         = local.vcn_id
  filter {
    name   = "display_name"
    values = [var.network_subnet_name]
  }
}


/********** FSS Accessors **********/

data "oci_identity_compartments" "MTCOMPARTMENTS" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.mt_compartment_name]
  }
}

data "oci_file_storage_exports" "EXPORTPATH" {
  compartment_id      = local.mt_compartment_id
  export_set_id = local.mount_target_id
}


data "oci_file_storage_mount_targets" "TESTMOUNTTARGETS" {
  #Required
  availability_domain = var.fss_mount_target_availability_domain
  compartment_id      = local.mt_compartment_id
  filter {
    name   = "display_name"
    values = ["${var.fss_mount_target_name}"]
  }
}

data "oci_core_private_ip" "MOUNTPRIVATEIP" {
  private_ip_id = local.mount_target_private_ip_id
}

locals {

  #Subnet OCID local accessors
  subnet_ocid = length(data.oci_core_subnets.SUBNET.subnets) > 0 ? data.oci_core_subnets.SUBNET.subnets[0].id : null

  # Compartment OCID Local Accessor 
  compartment_id    = lookup(data.oci_identity_compartments.COMPARTMENTS.compartments[0], "id")
  nw_compartment_id = lookup(data.oci_identity_compartments.NWCOMPARTMENTS.compartments[0], "id")
  # VCN OCID Local Accessor
  vcn_id = lookup(data.oci_core_vcns.VCN.virtual_networks[0], "id")

  # FSS/Mount Target Local Accessors
  mount_target_private_ip_id = data.oci_file_storage_mount_targets.TESTMOUNTTARGETS.mount_targets[0].private_ip_ids[0]
  mt_compartment_id          = var.mt_compartment_id != "" ? var.mt_compartment_id : lookup(data.oci_identity_compartments.MTCOMPARTMENTS.compartments[0], "id")
  mount_target_id            = data.oci_file_storage_mount_targets.TESTMOUNTTARGETS.mount_targets[0].export_set_id
  mount_target_CIDR_Block    = "0.0.0.0/0"
  mount_target_private_ip    = data.oci_core_private_ip.MOUNTPRIVATEIP.ip_address

  fss_export_path = data.oci_file_storage_exports.EXPORTPATH.exports[0].path
}
