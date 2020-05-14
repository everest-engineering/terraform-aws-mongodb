# Provision MongoDB in Private Subnet
This example provision mongodb server in a given VPC and in a private subnet.

1. Configure AWS Credentials as environment variables:

```shell script
export AWS_ACCESS_KEY_ID="ACCESS_KEY_HERE"
export AWS_SECRET_ACCESS_KEY="SECRET_ACCESS_KEY_HERE"
export AWS_DEFAULT_REGION="REGION_HERE"
```

2. If you don't have any existing EBS volume, Bastion Host then create EBS volume, Bastion Host 
in a new VPC using terraform script in prerequisite.

```shell script
cd terraform-mongodb-provisioning/mongo-provisioner-ec2/examples/mongodb-in-private-subnet/prerequisite
terraform init
terraform plan
terraform apply
```

3. Provision MongoDB:
Configure the existing/created `ebs_volume_id`, `bastion_host` as variables in `mongodb-in-private-subnet/main.tf`.

```shell script
cd terraform-mongodb-provisioning/mongo-provisioner-ec2/examples/mongodb-in-private-subnet
terraform init
terraform plan
terraform apply
```

4. Destroy:

```shell script
cd terraform-mongodb-provisioning/mongo-provisioner-ec2/examples/mongodb-in-private-subnet
terraform destroy
```