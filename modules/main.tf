# Random resource used to create unique resource names
resource "random_id" "rid" {
  byte_length = 5
}

#---------------------------------------------------
# AWS Sagemaker model
#---------------------------------------------------
resource "aws_sagemaker_model" "sagemaker_model" {
  count = var.create_sagemaker_model ? 1 : 0

  name               = "my-model-${random_id.rid.dec}"
  execution_role_arn = aws_iam_role.example.arn

  enable_network_isolation = var.sagemaker_model_enable_network_isolation

  dynamic "primary_container" {
    iterator = primary_container
    for_each = var.sagemaker_model_primary_container

    content {
      image = lookup(primary_container.value, "image", null)

      model_data_url     = lookup(primary_container.value, "model_data_url", null)
      container_hostname = lookup(primary_container.value, "container_hostname", null)
      environment        = lookup(primary_container.value, "environment", null)
    }
  }

  dynamic "container" {
    iterator = container
    for_each = var.sagemaker_model_container

    content {
      image = lookup(container.value, "image", null)

      model_data_url     = lookup(container.value, "model_data_url", null)
      container_hostname = lookup(container.value, "container_hostname", null)
      environment        = lookup(container.value, "environment", null)
    }
  }

  dynamic "vpc_config" {
    iterator = vpc_config
    for_each = var.sagemaker_model_vpc_config

    content {
      subnets            = lookup(vpc_config.value, "subnets", null)
      security_group_ids = lookup(vpc_config.value, "security_group_ids", null)
    }
  }

  tags = merge(
    {
      Name = "department1_recommendation"
    },
    var.model_tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}

# IAM role to provide Sagemaker permission to call other services
resource "aws_iam_role" "example" {
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [aws_iam_policy.s3_read_policy.arn]
}

# IAM policy definition for Sagemaker to assume role
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

# Iam policy for Sagemaker to have read access on S3 objects
resource "aws_iam_policy" "s3_read_policy" {
  name = "policy-618033-${random_id.rid.dec}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}