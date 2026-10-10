variable "github_repository_username" {
  description = "GitHub username that owns the repos"
  type        = string
  default     = "kealeee"
}

variable "infra_repository_name" {
  description = "GitHub repo for the Terraform infrastructure"
  type        = string
  default     = "kean-ecs-infra"
}

variable "apps_repository_name" {
  description = "GitHub repo for the Flask apps"
  type        = string
  default     = "kean-ecs-apps"
}

variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "kean"
}