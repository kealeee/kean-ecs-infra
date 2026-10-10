# Shared course VPC (the default VPC in this account has no subnets)
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Public subnets only: tasks get a public IP to pull images and serve traffic
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

# Look up each subnet so we can see which AZ it is in
data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

# Keep only subnets in AZs that support Fargate
locals {
  fargate_subnet_ids = [
    for s in data.aws_subnet.public : s.id
    if !contains(var.excluded_az_ids, s.availability_zone_id)
  ]
}