# Required Variables

key_name = "lucidum"
# MUST CHANGE to your keypair

availability_zone = "us-west-1a"
# Your AWS availability zone: change as needed
# (make sure the subnet is within this zone)

aws_region = "us-west-1"
# Your AWS region: change as needed

instance_size = "r5.4xlarge"
# Your EC2 instance type: change as needed
# t3.2xlarge is recommended

environment = "prod"
# Your AWS environment: change as needed

associate_public_ip_address = true
# Create and associate a public elasic IP (EIP) address with your EC2 instance: change as needed

trusted_cidrs = [
  "10.0.0.0/8",
  "192.168.0.0/16",
  "172.16.0.0/12",
  "50.18.235.151/32",
  "54.151.122.224/32",
]
# Your trusted CIDR IP address ranges for accessing the EC2 instance: change as needed
# (make sure your computer's IP address is within the IP ranges to access the EC2 instance)
# Private CIDRs and Lucidum Jumphosts are included in above list

source_ami_account_number = "308025194586"
# Lucidum AMI account: Don't change this line

playbook_version = "v1.0.30"
# Lucidum Playbook Version: change when new version is released

product_version = "v2.5.0"
# Lucidum Product Version: change when new version is released

playbook_edition = "enterprise"
# Lucidum Product Edition: Don't change this line



# Optional Overrides

#aws_profile = ""

#security_group_id = ""

#subnet_id = ""

#vpc_id = ""

#instance_profile_name = ""

#backup_ebs_volume_id = ""

#lucidum_ami_id = ""

#data_ebs_volume = ""

#kinesis_table = false

#tags = {}
