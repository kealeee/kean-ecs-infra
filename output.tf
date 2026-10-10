# Copy these into the apps repo's GitHub Actions variables
output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "s3_ecs_service" {
  value = "${var.name_prefix}-s3-service"
}

output "sqs_ecs_service" {
  value = "${var.name_prefix}-sqs-service"
}

output "s3_ecr_repository" {
  value = aws_ecr_repository.s3_service.name
}

output "sqs_ecr_repository" {
  value = aws_ecr_repository.sqs_service.name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.uploads.bucket
}

output "sqs_queue_url" {
  value = aws_sqs_queue.messages.url
}