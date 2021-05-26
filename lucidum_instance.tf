provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  vpc_id             = var.vpc_id != "" ? var.vpc_id : aws_vpc.lucidum[0].id
  subnet_id          = var.subnet_id != "" ? var.subnet_id : aws_subnet.lucidum[0].id
  secgroup_id        = var.security_group_id != "" ? var.security_group_id : aws_security_group.lucidum[0].id
  profile_name       = var.instance_profile_name != "" ? var.instance_profile_name : aws_iam_instance_profile.lucidum[0].name
  lucidum_edition    = var.playbook_edition == "enterprise" ? "ubuntu18" : var.playbook_edition
  lucidum_ami        = "lucidum-${local.lucidum_edition}-edition-${var.playbook_version}"
  lucidum_version    = "lucidum-${var.playbook_edition}-${var.playbook_version}-${var.product_version}"
  lucidum_deployment = "lucidum-${var.playbook_edition}-${var.playbook_version}-${var.product_version}-${var.environment}"
  tags               = merge({ Name = local.lucidum_deployment }, var.tags)
}


resource "aws_vpc" "lucidum" {
  count                            = var.vpc_id == "" ? 1 : 0
  cidr_block                       = var.lucidum_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = false
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name        = local.lucidum_version
    Environment = var.environment
  }
}

resource "aws_subnet" "lucidum" {
  count                           = var.subnet_id == "" ? 1 : 0
  vpc_id                          = aws_vpc.lucidum[0].id
  cidr_block                      = var.lucidum_cidr
  availability_zone               = var.availability_zone
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = false

  tags = {
    Name        = local.lucidum_version
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "lucidum" {
  count  = var.vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.lucidum[0].id

  tags = {
    Name        = local.lucidum_version
    Environment = var.environment
  }
}

resource "aws_route_table" "lucidum" {
  count  = var.vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.lucidum[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lucidum[0].id
  }

  tags = {
    Name        = local.lucidum_version
    Environment = var.environment
  }
}

resource "aws_route_table_association" "lucidum"{
  count  = var.subnet_id == "" ? 1 : 0
  subnet_id = aws_subnet.lucidum[0].id
  route_table_id = aws_route_table.lucidum[0].id
}

data "aws_ami" "lucidum_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${local.lucidum_ami}*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.source_ami_account_number]
}

resource "aws_security_group" "lucidum" {
  count       = var.security_group_id == "" ? 1 : 0
  name        = local.lucidum_deployment
  description = local.lucidum_deployment
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_security_group_rule" "allow_ssh" {
  count             = var.security_group_id == "" && var.playbook_edition != "community" ? 1 : 0
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.lucidum[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_api" {
  count             = var.security_group_id == "" && var.playbook_edition != "community" ? 1 : 0
  type              = "ingress"
  from_port         = 5500
  to_port           = 5501
  protocol          = "tcp"
  security_group_id = aws_security_group.lucidum[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_airflow" {
  count             = var.security_group_id == "" && var.playbook_edition != "community" ? 1 : 0
  type              = "ingress"
  to_port           = 9080
  from_port         = 9080
  protocol          = "tcp"
  security_group_id = aws_security_group.lucidum[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_update_manager_api" {
  count             = var.security_group_id == "" && var.playbook_edition != "community" ? 1 : 0
  type              = "ingress"
  to_port           = 8000
  from_port         = 8000
  protocol          = "tcp"
  security_group_id = aws_security_group.lucidum[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_icmp" {
  count             = var.security_group_id == "" ? 1 : 0
  type              = "ingress"
  to_port           = -1
  from_port         = -1
  protocol          = "icmp"
  security_group_id = aws_security_group.lucidum[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_http" {
  count             = var.security_group_id == "" ? 1 : 0
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lucidum[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_https" {
  count             = var.security_group_id == "" ? 1 : 0
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lucidum[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_instance" "lucidum" {
  ami                         = var.lucidum_ami_id == "" ? data.aws_ami.lucidum_ami.id : var.lucidum_ami_id
  instance_type               = var.instance_size
  key_name                    = var.key_name
  subnet_id                   = local.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [ local.secgroup_id ]
  iam_instance_profile        = local.profile_name
  availability_zone           = var.availability_zone
  user_data                   = file("${abspath(path.root)}/../boot_scripts/boot_${local.lucidum_edition}.sh")

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  tags = {
    Name = local.lucidum_deployment
  }
}

resource "aws_volume_attachment" "lucidum_data" {
  count       = var.data_ebs_volume ? 1 : 0
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.lucidum_data[0].id
  instance_id = aws_instance.lucidum.id
}

resource "aws_volume_attachment" "lucidum_backup" {
  count       = var.backup_ebs_volume_id == "" ? 0 : 1
  device_name = "/dev/sdg"
  volume_id   = var.backup_ebs_volume_id
  instance_id = aws_instance.lucidum.id
}

resource "aws_ebs_volume" "lucidum_data" {
  count             = var.data_ebs_volume ? 1 : 0
  size              = 50
  availability_zone = var.availability_zone
  tags = {
    Name = "${local.lucidum_deployment}_data"
  }
}

resource "aws_iam_instance_profile" "lucidum" {
  count = var.instance_profile_name == "" ? 1 : 0
  name  = local.lucidum_deployment
  role  = aws_iam_role.lucidum[0].name
}

resource "aws_iam_role" "lucidum" {
  count              = var.instance_profile_name == "" ? 1 : 0
  name               = local.lucidum_deployment
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.lucidum_assume_role.json
  tags               = { Name = local.lucidum_deployment }
}

data "aws_iam_policy_document" "lucidum_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lucidum" {
  count  = var.instance_profile_name == "" ? 1 : 0
  name   = local.lucidum_deployment
  role   = aws_iam_role.lucidum[0].name
  policy = file("../x_account_deployment/lucidum_assume_role_policy.json")
}

output "lucidum_instance_id" {
  value = aws_instance.lucidum.id
}

output "lucidum_instance_private_ip" {
  value = aws_instance.lucidum.private_ip
}

output "lucidum_instance_public_ip" {
  value = aws_instance.lucidum.public_ip
}

output "instance_tags" {
  value = local.tags
}
