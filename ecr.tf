# One image repository per service. The apps repo pushes ":latest" here.
resource "aws_ecr_repository" "s3_service" {
  name                 = "${var.name_prefix}-s3-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "sqs_service" {
  name                 = "${var.name_prefix}-sqs-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}