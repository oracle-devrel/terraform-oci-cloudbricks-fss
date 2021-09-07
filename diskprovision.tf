# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# diskprovision.tf
#
# Purpose: The following script triggers the mounting process of a FSS on top of a mounting point


resource "null_resource" "install_prereq_linux_os" {
count = var.os_type == "linux" ? 1 : 0
  depends_on = [
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]
  connection {
    type        = "ssh"
    host        = var.compute_private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  provisioner "remote-exec" {

    inline = [
      "set +x",
      "sudo yum install nfs-utils -y",
    ]
  }
}


resource "null_resource" "mount_disk_linux" {
  depends_on = [
    null_resource.install_prereq_linux_os,
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]

  count = var.os_type == "linux" ? length(oci_file_storage_export.ExportFileSystemMount) : 0

  connection {
    type        = "ssh"
    host        = var.compute_private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }
  provisioner "remote-exec" {

    inline = [
      "set +x",
      "sudo systemctl stop firewalld",
      "sudo systemctl disable firewalld",
      "sudo mkdir -p /u0${count.index + 1}/",
      "echo ${local.mount_target_private_ip}:/${count.index < "9" ? "${var.compute_display_name}${var.export_path_base}${var.label_zs[0]}${count.index + 1}" : "${var.compute_display_name}${var.export_path_base}${var.label_zs[1]}${count.index + 1}"} /u0${count.index + 1} nfs defaults 0 0 | sudo tee -a /etc/fstab",
      "sudo mount -a",
      "sudo chown -R opc:opc /u0${count.index + 1}/",
      "cd /",
    ]
  }
}

resource "null_resource" "install_prereq_ubuntu_os" {
count = var.os_type == "ubuntu" ? 1 : 0
  depends_on = [
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]
  connection {
    type        = "ssh"
    host        = var.compute_private_ip
    user        = "ubuntu"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  provisioner "remote-exec" {

    inline = [
      "set +x",
      "sudo apt update",
      "sudo apt install nfs-common -y",
    ]
  }
}

resource "null_resource" "mount_disk_ubuntu" {
  depends_on = [
    null_resource.install_prereq_ubuntu_os,
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]

  count = var.os_type == "ubuntu" ? length(oci_file_storage_export.ExportFileSystemMount) : 0

  connection {
    type        = "ssh"
    host        = var.compute_private_ip
    user        = "ubuntu"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }
  provisioner "remote-exec" {

    inline = [
      "set +x",
      "sudo mkdir -p /u0${count.index + 1}/",
      "echo ${local.mount_target_private_ip}:/${count.index < "9" ? "${var.compute_display_name}${var.export_path_base}${var.label_zs[0]}${count.index + 1}" : "${var.compute_display_name}${var.export_path_base}${var.label_zs[1]}${count.index + 1}"} /u0${count.index + 1} nfs defaults 0 0 | sudo tee -a /etc/fstab",
      "sudo mount -a",
      "sudo chown -R ubuntu:ubuntu /u0${count.index + 1}/",
      "cd /",
    ]
  }
}


resource "null_resource" "install_prereq_windows_os" {
count = var.os_type == "windows" ? 1 : 0
  depends_on = [
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]
provisioner "remote-exec" {
    connection {
      type     = "winrm"
      agent    = false
      timeout  = "1m"
      host     = var.compute_private_ip
      user     = "opc"
      password = var.win_os_password
      port     = 5986
      https    = var.is_winrm_configured_with_ssl
      insecure = "true"
    }

    inline = [
      "${local.powershell} Install-WindowsFeature NFS-Client",
      "${local.powershell} Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False",
    ]
  } 
}


resource "null_resource" "mount_disk_windows" {
  depends_on = [
    null_resource.install_prereq_ubuntu_os,
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]

  count = var.os_type == "windows" ? length(oci_file_storage_export.ExportFileSystemMount) : 0

    connection {
      type     = "winrm"
      agent    = false
      timeout  = "1m"
      host     = var.compute_private_ip
      user     = "opc"
      password = var.win_os_password
      port     = 5986 
      https    = var.is_winrm_configured_with_ssl
      insecure = "true"
    }
  provisioner "remote-exec" {

    inline = [            
      "${local.powershell} New-PSDrive ${var.disk_unit} -PsProvider FileSystem -Root \\\\${local.mount_target_private_ip}\\${count.index < "9" ? "${var.compute_display_name}${var.export_path_base}${var.label_zs[0]}${count.index + 1}" : "${var.compute_display_name}${var.export_path_base}${var.label_zs[1]}${count.index + 1}"} ",
    ]
  }
}




