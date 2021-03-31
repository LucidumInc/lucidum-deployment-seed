resource "aws_dynamodb_table" "kinesis_dynamodb" {
  count          = var.kinesis_table ? 1 : 0
  name           = local.lucidum_deployment
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "shard"

  attribute {
    name = "shard"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = local.lucidum_deployment
    Version     = local.lucidum_version
    Environment = var.environment
  }
}
