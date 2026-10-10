variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for every resource name, so they are easy to find in the shared account"
  type        = string
  default     = "kean"
}

variable "excluded_az_ids" {
  description = "AZ IDs where Fargate is not supported (use1-az3 in us-east-1)"
  type        = list(string)
  default     = ["use1-az3"]
}

variable "vpc_name" {
  description = "Name tag of the VPC to run the ECS services in"
  type        = string
  default     = "sctp-vpc-ce13"
}