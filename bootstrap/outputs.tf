output "infra_oidc_role_arn" {
  description = "Put this in kean-ecs-infra as secret OIDC_ROLE"
  value       = aws_iam_role.infra_oidc_role.arn
}

output "apps_oidc_role_arn" {
  description = "Put this in kean-ecs-apps as secret OIDC_ROLE"
  value       = aws_iam_role.apps_oidc_role.arn
}