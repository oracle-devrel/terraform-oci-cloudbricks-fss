# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# diskprovision.tf
#
# Purpose: The following script triggers the mounting process of a FSS on top of a mounting point


resource "null_resource" "install_prereq_linux_os" {
  count = var.os_type == "linux" ? length(var.compute_private_ips) : 0
  depends_on = [
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]

  connection {
    type        = "ssh"
    host        = var.compute_private_ips[count.index]
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
  count = var.os_type == "linux" ? length(oci_file_storage_export.ExportFileSystemMount) * length(var.compute_private_ips) : 0
  depends_on = [
    null_resource.install_prereq_linux_os,
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]

  connection {
    type        = "ssh"
    host        = var.compute_private_ips[floor(count.index / length(oci_file_storage_export.ExportFileSystemMount))]
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "set +x",
      "sudo systemctl stop firewalld",
      "sudo systemctl disable firewalld",
      "sudo systemctl daemon-reload",
      "sudo mkdir -p /u0${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}/",
      "echo ${local.mount_target_private_ip}:/${count.index < "9" ? "${var.fss_disk_group_base}${var.export_path_base}${var.label_zs[0]}${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}" : "${var.fss_disk_group_base}${var.export_path_base}${var.label_zs[1]}${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}"} /u0${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1} nfs defaults 0 0 | sudo tee -a /etc/fstab",
      "sudo mount -a",
      "sudo chown -R opc:opc /u0${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}/",
      "cd /",
    ]
  }
}

resource "null_resource" "install_prereq_ubuntu_os" {
  count = var.os_type == "ubuntu" ? length(var.compute_private_ips) : 0
  depends_on = [
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]

  connection {
    type        = "ssh"
    host        = var.compute_private_ips[count.index]
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
  count = var.os_type == "ubuntu" ? length(oci_file_storage_export.ExportFileSystemMount) * length(var.compute_private_ips) : 0
  depends_on = [
    null_resource.install_prereq_ubuntu_os,
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]

  connection {
    type        = "ssh"
    host        = var.compute_private_ips[floor(count.index / length(oci_file_storage_export.ExportFileSystemMount))]
    user        = "ubuntu"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "set +x",
      "sudo mkdir -p /u0${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}/",
      "echo ${local.mount_target_private_ip}:/${count.index < "9" ? "${var.fss_disk_group_base}${var.export_path_base}${var.label_zs[0]}${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}" : "${var.fss_disk_group_base}${var.export_path_base}${var.label_zs[1]}${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}"} /u0${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1} nfs defaults 0 0 | sudo tee -a /etc/fstab",
      "sudo mount -a",
      "sudo chown -R ubuntu:ubuntu /u0${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}/",
      "cd /",
    ]
  }
}


resource "null_resource" "install_prereq_windows_os" {
  count = var.os_type == "windows" ? length(var.compute_private_ips) : 0
  depends_on = [
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]

  provisioner "remote-exec" {
    connection {
      type     = "winrm"
      agent    = false
      timeout  = "5m"
      host     = var.compute_private_ips[count.index]
      user     = "opc"
      password = var.win_os_password
      port     = 5986
      https    = var.is_winrm_configured_with_ssl
      insecure = "true"
    }

    inline = [
      "${local.powershell} Install-WindowsFeature NFS-Client",
      "${local.powershell} Set-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\ClientForNFS\\CurrentVersion\\Default -Name AnonymousUid -Value 0",
      "${local.powershell} Set-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\ClientForNFS\\CurrentVersion\\Default -Name AnonymousGid -Value 0",
      "${local.powershell} Stop-Service -Name NfsClnt",
      "${local.powershell} Restart-Service -Name NfsRdr",
      "${local.powershell} Start-Service -Name NfsClnt",
    ]
  }
}


resource "null_resource" "mount_disk_windows" {
  count = var.os_type == "windows" ? length(oci_file_storage_export.ExportFileSystemMount) * length(var.compute_private_ips) : 0
  depends_on = [
    null_resource.install_prereq_windows_os,
    oci_file_storage_file_system.FileStorage,
    oci_file_storage_export.ExportFileSystemMount
  ]

  triggers = {
    compute_private_ip           = var.compute_private_ips[floor(count.index / length(oci_file_storage_export.ExportFileSystemMount))]
    win_os_password              = var.win_os_password
    is_winrm_configured_with_ssl = var.is_winrm_configured_with_ssl
    fss_disk_group_base          = var.fss_disk_group_base
    export_path_base             = var.export_path_base
    label_zs_0                   = var.label_zs[0]
    label_zs_1                   = var.label_zs[1]
    drive_letter                 = var.windows_drive_letters[count.index % length(oci_file_storage_export.ExportFileSystemMount)]
  }

  connection {
    type     = "winrm"
    agent    = false
    timeout  = "5m"
    host     = self.triggers.compute_private_ip
    user     = "opc"
    password = self.triggers.win_os_password
    port     = 5986
    https    = self.triggers.is_winrm_configured_with_ssl
    insecure = "true"
  }

  provisioner "remote-exec" {
    inline = [
      "net use ${self.triggers.drive_letter}: \\\\${local.mount_target_private_ip}\\${count.index < "9" ? "${self.triggers.fss_disk_group_base}${self.triggers.export_path_base}${self.triggers.label_zs_0}${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}" : "${self.triggers.fss_disk_group_base}${self.triggers.export_path_base}${self.triggers.label_zs_1}${count.index % length(oci_file_storage_export.ExportFileSystemMount) + 1}"} /persistent:yes"
    ]
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "net use ${self.triggers.drive_letter}: /delete"
    ]
  }
}
