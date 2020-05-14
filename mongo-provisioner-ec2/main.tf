locals {
  ami_id = var.ami_id == "" ? data.aws_ami.ami.id : var.ami_id
  public_key_name = "mongo-publicKey"
  device_name = "/dev/xvdh"
  ansible_host_group = ["db-mongodb"]
}

data "aws_vpc" "selected_vpc" {
  id = var.vpc_id
}

resource "aws_key_pair" "mongo_keypair" {
  key_name   = local.public_key_name
  public_key = var.public_key
}

resource "aws_instance" "mongo_server" {
  ami                    = local.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg_mongodb.id]
  key_name               = aws_key_pair.mongo_keypair.key_name
  availability_zone      = var.availability_zone
  tags                   = var.tags

  connection {
    host         = var.bastion_host == "" ? self.public_ip : self.private_ip
    type         = "ssh"
    user         = var.ssh_user
    private_key  = var.private_key
    bastion_host = var.bastion_host
    agent        = true
  }

  provisioner "file" {
    source      = "${path.module}/provisioning/wait-for-cloud-init.sh"
    destination = "/tmp/wait-for-cloud-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ln -s /usr/bin/python3 /usr/bin/python",
      "chmod +x /tmp/wait-for-cloud-init.sh",
      "/tmp/wait-for-cloud-init.sh",
    ]
  }
}

resource "aws_volume_attachment" "mongo-data-vol-attachment" {
  device_name = local.device_name
  volume_id   = var.ebs_volume_id
  instance_id = aws_instance.mongo_server.id

  skip_destroy = true

  connection {
    host         = var.bastion_host == "" ? aws_instance.mongo_server.public_ip : aws_instance.mongo_server.private_ip
    type         = "ssh"
    user         = var.ssh_user
    private_key  = var.private_key
    bastion_host = var.bastion_host
    agent        = true
  }

  provisioner "file" {
    source      = "${path.module}/provisioning/mount-data-volume.sh"
    destination = "/tmp/mount-data-volume.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/mount-data-volume.sh",
      "/tmp/mount-data-volume.sh",
    ]
  }

  provisioner "ansible" {
    plays {
      playbook {
        file_path = "${path.module}/provisioning/playbook.yaml"
      }
      extra_vars = {
        mongodb_version = var.mongodb_version
      }
      groups = local.ansible_host_group
    }
  }
}