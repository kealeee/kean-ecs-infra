# Service 1 uploads files here
resource "aws_s3_bucket" "uploads" {
  bucket_prefix = "${var.name_prefix}-ecs-uploads-"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket                  = aws_s3_bucket.uploads.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Service 2 sends messages here
resource "aws_sqs_queue" "messages" {
  name                    = "${var.name_prefix}-ecs-messages"
  sqs_managed_sse_enabled = true
}