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
      "sudo mkdir -p /u0${count.index + 1}/",
      "echo ${local.mount_target_private_ip}:${local.fss_export_path} /u0${count.index + 1}/ nfs defaults 0 0 | sudo tee -a /etc/fstab",
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
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  provisioner "remote-exec" {

    inline = [
      "set +x",
      "echo UBUNTU ",
    ]
  }

}


resource "null_resource" "install_prereq_windows_os" {
count = var.os_type == "windows" ? 1 : 0
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
      "echo Pichula",
    ]
  }

}



