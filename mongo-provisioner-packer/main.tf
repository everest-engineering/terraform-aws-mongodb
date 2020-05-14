data "aws_ami" "image" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [join("_", [var.platform, "mongodb-${var.mongodb_version}", var.ami_version])]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
}

resource "aws_instance" "mongodb" {
  ami                         = var.ami == "" ? data.aws_ami.image.id : var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  tags                        = var.tags
  user_data                   = data.template_file.user_data.rendered
}

