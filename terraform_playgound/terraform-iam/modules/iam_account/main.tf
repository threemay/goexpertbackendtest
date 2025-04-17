module "iam_account" {
  source = "terraform-aws-modules/iam/aws//modules/iam-account"
  account_alias = var.account_alias
  create_account_password_policy = true
  minimum_password_length = 12
  require_uppercase_characters = true
  require_lowercase_characters = true
  require_numbers = true
  require_symbols = true
  max_password_age = 90
  password_reuse_prevention = 5
}
