
resource "oci_file_storage_file_system" "FileStorage" {
  count               = var.num_of_fss
  availability_domain = var.fss_mount_target_availability_domain
  compartment_id      = local.compartment_id
  display_name        = count.index < "9" ? "${var.fss_disk_group_base}_${var.fss_disk_name_base}${var.label_zs[0]}${count.index + 1}" : "${var.fss_disk_group_base}_${var.fss_disk_name_base}${var.label_zs[1]}${count.index + 1}"
}

resource "oci_file_storage_export" "ExportFileSystemMount" {
  count          = var.num_of_fss
  export_set_id  = local.mount_target_id
  file_system_id = oci_file_storage_file_system.FileStorage[count.index].id
  path           = count.index < "9" ? "/${var.fss_disk_group_base}${var.export_path_base}${var.label_zs[0]}${count.index + 1}" : "/${var.fss_disk_group_base}${var.export_path_base}${var.label_zs[1]}${count.index + 1}"



  export_options {
    source                         = local.mount_target_CIDR_Block
    access                         = "READ_WRITE"
    identity_squash                = "NONE"
    require_privileged_source_port = false
  }
}
