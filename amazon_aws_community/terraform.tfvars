# Required Variables

environment = "prod"
# Your AWS environment: change as needed

availability_zone = "us-west-1b"
# Your AWS availability zone: change as needed
# Make sure the subnet is within this zone

aws_region = "us-west-1"
# Your AWS region: change as needed

source_ami_account_number = "308025194586"
# Lucidum AMI account: Don't change this line

playbook_version = "v0.1.21"
# Lucidum Product Version: change when new version is released

playbook_edition = "community"
# Lucidum Product Edition: Don't change this line

instance_size = "t3.2xlarge"
# Your EC2 instance type: change as needed
# t3.2xlarge is recommended

associate_public_ip_address = true
# Associate a public IP address with your EC2 instance: change as needed

subnet_id = "subnet-0123456789abcdef0"
# Your AWS subnet ID: change as needed
# Make sure the subnet is within the availability zone

vpc_id = "vpc-0123456789abcdef0"
# Your AWS VPC ID: change as needed

trusted_cidrs = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
# Your trusted CIDR IP address ranges for accessing the EC2 instance: change as needed
# Make sure your computer's IP address is within the IP ranges to access the EC2 instance


# Optional Overrides

#aws_profile = ""

#key_name = ""

#security_group_id = ""

#instance_profile_name = ""

#backup_ebs_volume_id = ""

#lucidum_ami_id = ""

#data_ebs_volume = ""
