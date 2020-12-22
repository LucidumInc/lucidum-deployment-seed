# required variables

environment = "prod"

availability_zone = "us-west-1b"

source_ami_account_number = "308025194586"  # lucidum account

playbook_version = "v0.1.11"

playbook_edition = "community"

instance_size = "t3.large"

associate_public_ip_address = true

subnet_id = "subnet-dd498a87"

vpc_id = "vpc-9c2ce8fa"

key_name = "lucidum-secondary"

trusted_cidrs = [ "10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12", "69.113.180.153/32" ]


# optional overrides

aws_region = "us-west-1"

aws_profile = "lucidum-secondary"

#security_group_id = ""

#instance_profile_name = ""

#backup_ebs_volume_id = ""

#lucidum_ami_id = ""

#data_ebs_volume = ""
