# required variables

environment = "prod"

availability_zone = "us-west-1b"

aws_region = "us-west-1"

source_ami_account_number = "308025194586"  # lucidum account

playbook_version = "v0.1.13"

playbook_edition = "community"

instance_size = "t3.2xlarge"

associate_public_ip_address = true

subnet_id = "subnet-12345678"

vpc_id = "vpc-12345678"

trusted_cidrs = [ "10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12" ]



# optional overrides

#key_name = ""

#aws_profile = ""

#security_group_id = ""

#instance_profile_name = ""

#backup_ebs_volume_id = ""

#lucidum_ami_id = ""

#data_ebs_volume = ""
