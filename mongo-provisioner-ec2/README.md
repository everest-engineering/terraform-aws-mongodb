# Terraform MongoDB Provider for AWS

This module provision MongoDB server on AWS EC2 instance using Ansible provisioner.
This module uses [undergreen.mongodb](https://galaxy.ansible.com/undergreen/mongodb) Ansible role to provision mongodb.
So, you can use any of the [platforms supported by **undergreen.mongodb**](https://github.com/UnderGreen/ansible-role-mongodb/blob/master/README.md) role while selecting the AMI ID.

## Dependencies

### 1. Ansible provisioner
This module depends on the Ansible provisioner. 
See the [installation instructions](https://github.com/radekg/terraform-provisioner-ansible#installation).

Download a [Prebuilt release available on GitHub](https://github.com/radekg/terraform-provisioner-ansible/releases),
rename it to **terraform-provisioner-ansible** and place it in **~/.terraform.d/plugins** directory.

### 2. Install Ansible role undergreen.mongodb

`> ansible-galaxy install undergreen.mongodb --ignore-errors --ignore-certs`

### 3. SSH Keys
User needs to provide SSH keys for the **terraform-provider-mongodb** module to perform remote provisioning.

You can generate SSH keys using the following command:

`$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`

For more info on generating SSH keys refer https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

## Prerequisite

The data should be persistent across the EC2 restarts/termination. 
So a better approach would be to store MongoDB data on externally created EBS volume and attach/mount to EC2 instance.

> Note: To attach EBS volume to an EC2 instance they both need to be in same availability_zone.

You can provision EBS volume as follows:

* Configure **region**, **availability_zone**, **volume type**, **volume size** in **ebs-setup/main.tf** as follows:**

```hcl-terraform
provider "aws" {
  region  = "us-east-1"
}

resource "aws_ebs_volume" "mongo-data-vol" {
  availability_zone = var.availability_zone
  type              = "gp2"
  size              = "10"

  tags = {
    Name        = "mongo-data-ebs-volume"
  }
}
```

* **Create EBS volume:**

```shell script
cd ebs-setup
ebs-setup> terraform apply
...
...
Outputs:

availability_zone = us-east-1a
ebs-vol-id = vol-082d1c33d045fgt98
```

## How to use this module?

Use the EBS volume id and availability_zone output values from previous step and configure them as local variables.

1. Create a file **terraform-mongo-example/main.tf** as follows:

```hcl-terraform
provider "aws" {
  region  = "us-east-1"
  profile = "terraform-provisioner-ansible"
}

locals {
  availability_zone = "us-east-1a"
  ebs_volume_id     = "vol-082d1c33d045fgt98"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "subnet" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = local.availability_zone
}

module "mongodb" {
  source            = "path/to/module"
  vpc_id            = data.aws_vpc.default.id
  subnet_id         = data.aws_subnet.subnet.id
  instance_type     = "t2.micro"
  ami_filter_name   = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  ebs_volume_id     = local.ebs_volume_id
  availability_zone = local.availability_zone
  volume_size       = "8"
  private_key       = file("~/.ssh/id_rsa")
  public_key        = file("~/.ssh/id_rsa.pub")
  environment_tag   = "terraform-mongo-test"
}

output "mongo_server_public_ip" {
  value = module.mongodb.mongo_server_public_ip
}

output "mongo_connect_url" {
  value = module.mongodb.mongo_connect_url
}
```

2. Configure AWS Credentials as environment variables:

```shell script
export AWS_ACCESS_KEY_ID="ACCESS_KEY_HERE"
export AWS_SECRET_ACCESS_KEY="SECRET_ACCESS_KEY_HERE"
export AWS_DEFAULT_REGION="REGION_HERE"
```

3. Provision MongoDB on AWS:

```shell script
cd terraform-provider-mongodb/examples/standalone-mongodb-ec2
terraform init
terraform plan
terraform apply
```

4. Destroy the provisioned infrastructure:

```shell script
cd terraform-provider-mongodb/examples/standalone-mongodb-ec2
terraform destroy
```

## Testing

1. Install Go https://golang.org/doc/install
2. Configure AWS Credentials as environment variables as mentioned above.

```shell script
cd test
go test -v
```