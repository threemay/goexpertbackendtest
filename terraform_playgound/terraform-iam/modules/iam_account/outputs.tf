output "account_alias" {
  description = "The alias of the AWS account"
  value       = module.iam_account.account_alias
}
