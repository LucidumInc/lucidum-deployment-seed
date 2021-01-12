# required variables

environment = "prod"                # change as needed

availability_zone = "us-west-1b"    # change as needed

aws_region = "us-west-1"            # change as needed

source_ami_account_number = "308025194586"  # Don't change this line

playbook_version = "v0.1.14"                # Don't change this line

playbook_edition = "community"              # Don't change this line

instance_size = "t3.2xlarge"        # change as needed

associate_public_ip_address = true  

subnet_id = "subnet-12345678"       # change as needed

vpc_id = "vpc-12345678"             # change as needed

trusted_cidrs = [ "10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12" ]   # change as needed

aws_profile = "default"             # change as needed


# optional overrides

#key_name = ""

#security_group_id = ""

#instance_profile_name = ""

#backup_ebs_volume_id = ""

#lucidum_ami_id = ""

#data_ebs_volume = ""
