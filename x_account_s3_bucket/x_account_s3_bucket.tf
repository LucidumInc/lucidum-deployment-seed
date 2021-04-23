resource "aws_s3_bucket" "lucidum_x_account_deploy" {
  bucket_prefix = "${var.stack_name}-"
  acl           = "private"

  tags = {
    Name        = var.stack_name
  }
}


data "aws_iam_policy_document" "lucidum_x_account_deploy" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.lucidum_x_account_deploy.arn,
      "${aws_s3_bucket.lucidum_x_account_deploy.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [
          "arn:aws:iam::906036546615:root",
          "arn:aws:iam::906036546615:role/lucidum-ec2-detection-prod",
          "arn:aws:iam::308025194586:root",
          "arn:aws:iam::308025194586:role/lucidum-ec2-detection-prod"
      ]
    }
  }
}


resource "aws_s3_bucket_policy" "lucidum_x_account_deploy" {
  bucket = aws_s3_bucket.lucidum_x_account_deploy.id
  policy = data.aws_iam_policy_document.lucidum_x_account_deploy.json
}


#resource "aws_s3_bucket_policy" "lucidum_x_account_deploy" {
#  bucket = aws_s3_bucket.lucidum_x_account_deploy.id
#
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Id      = "lucidumxaccountdeploy"
#    Statement = [
#      {
#        Sid       = "xaccountallow"
#        Effect    = "Allow"
#        Principal =  { "AWS": [
#          "arn:aws:iam::906036546615:root",
#          "arn:aws:iam::906036546615:role/lucidum-ec2-detection-prod",
#          "arn:aws:iam::308025194586:root",
#          "arn:aws:iam::308025194586:role/lucidum-ec2-detection-prod"
#        ]},
#        Action    = "s3:*"
#        Resource  = [
#          "arn:aws:s3:::${aws_s3_bucket.lucidum_x_account_deploy.id}",
#          "arn:aws:s3:::${aws_s3_bucket.lucidum_x_account_deploy.id}/*"
#        ],
#        Effect    = "Allow"
#      }
#    ]
#  })
#}

output "lucidum_x_account_deploy_s3_bucket" {
  value = aws_s3_bucket.lucidum_x_account_deploy.id
}
