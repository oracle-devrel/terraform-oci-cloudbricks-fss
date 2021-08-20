output "display_name" {
  description = "Display Name of FSS"
  value       = oci_file_storage_file_system.FileStorage.*.display_name
}

output "export_path_base" {
  description = "Export path of FSS"
  value       = oci_file_storage_export.ExportFileSystemMount.*.path
}

output "FSS" {
  description = "FSS Object"
  value       = oci_file_storage_file_system.FileStorage
}

output "mount_target_private_ip" {
  description = "Private IP of Mount Target"
  value       = local.mount_target_private_ip
}