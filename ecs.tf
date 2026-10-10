module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 7.5.0"

  cluster_name               = "${var.name_prefix}-ecs-cluster"
  cluster_capacity_providers = ["FARGATE"]

  services = {
    # ---------- Service 1: upload a file to S3 ----------
    "${var.name_prefix}-s3-service" = {
      cpu                = 256
      memory             = 512
      desired_count      = 1
      enable_autoscaling = false # fixed at 1 task; keeps it simple for the lab
      subnet_ids         = local.fargate_subnet_ids
      assign_public_ip   = true # default VPC has no NAT, so tasks need a public IP to pull from ECR

      container_definitions = {
        s3-app = {
          image                  = "${aws_ecr_repository.s3_service.repository_url}:latest"
          essential              = true
          readonlyRootFilesystem = false # Flask may write large uploads to /tmp
          portMappings = [{
            containerPort = 5001
            protocol      = "tcp"
          }]
          environment = [
            { name = "AWS_REGION", value = var.aws_region },
            { name = "BUCKET_NAME", value = aws_s3_bucket.uploads.bucket },
          ]
        }
      }

      tasks_iam_role_name = "${var.name_prefix}-s3-service-task"
      tasks_iam_role_statements = [{
        actions   = ["s3:PutObject"]
        resources = ["${aws_s3_bucket.uploads.arn}/*"]
      }]
      task_exec_iam_role_name = "${var.name_prefix}-s3-service-exec"

      security_group_ingress_rules = {
        app = {
          description = "Flask upload app"
          from_port   = 5001
          to_port     = 5001
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
      security_group_egress_rules = {
        all = {
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }

    # ---------- Service 2: send a message to SQS ----------
    "${var.name_prefix}-sqs-service" = {
      cpu                = 256
      memory             = 512
      desired_count      = 1
      enable_autoscaling = false
      subnet_ids         = local.fargate_subnet_ids
      assign_public_ip   = true

      container_definitions = {
        sqs-app = {
          image                  = "${aws_ecr_repository.sqs_service.repository_url}:latest"
          essential              = true
          readonlyRootFilesystem = false
          portMappings = [{
            containerPort = 5002
            protocol      = "tcp"
          }]
          environment = [
            { name = "AWS_REGION", value = var.aws_region },
            { name = "QUEUE_URL", value = aws_sqs_queue.messages.url },
          ]
        }
      }

      tasks_iam_role_name = "${var.name_prefix}-sqs-service-task"
      tasks_iam_role_statements = [{
        actions   = ["sqs:SendMessage"]
        resources = [aws_sqs_queue.messages.arn]
      }]
      task_exec_iam_role_name = "${var.name_prefix}-sqs-service-exec"

      security_group_ingress_rules = {
        app = {
          description = "Flask SQS app"
          from_port   = 5002
          to_port     = 5002
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
      security_group_egress_rules = {
        all = {
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }
  }
}