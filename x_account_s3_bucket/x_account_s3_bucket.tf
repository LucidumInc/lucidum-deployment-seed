resource "aws_s3_bucket" "lucidum_x_account_deploy" {
  bucket_prefix = "${var.stack_name}-"
  acl           = "private"

  tags = {
    Name        = var.stack_name
  }
}

resource "aws_s3_bucket_policy" "lucidum_x_account_deploy" {
  bucket = aws_s3_bucket.lucidum_x_account_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "lucidumxaccountdeploy"
    Statement = [
      {
        Sid       = "xaccountallow"
        Effect    = "Allow"
        Principal =  { "AWS": [
          "arn:aws:iam::906036546615:root",
          "arn:aws:iam::308025194586:root"
        
        ]},
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.lucidum_x_account_deploy.arn,
          "${aws_s3_bucket.lucidum_x_account_deploy.arn}/*",
        ]
      }
    ]
  })
}

output "lucidum_x_account_deploy_s3_bucket" {
  value = aws_s3_bucket.lucidum_x_account_deploy.id
}
