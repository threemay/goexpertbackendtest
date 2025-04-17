provider "aws" {
  region = "us-east-1"
}

# module "iam_account" {
#   source = "./modules/iam_account"
#   account_alias = "my-new-account"
# }

resource "aws_iam_policy" "example_policy" {
  name        = "example_policy"
  description = "An example policy"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_user" "example_user" {
  name = "example_user"
}

resource "aws_iam_user_policy_attachment" "example_user_policy_attachment" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_policy.example_policy.arn
}

# output "account_alias" {
#   value = module.iam_account.account_alias
# }
