# Define the SageMaker endpoint
resource "aws_sagemaker_endpoint" "example_endpoint" {
  name               = "example-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.example_configuration.name
}

# Define the SageMaker endpoint configuration
resource "aws_sagemaker_endpoint_configuration" "example_configuration" {
  name = "example-configuration"
  production_variants {
    variant_name           = "example-variant"
    initial_instance_count = 1
    instance_type          = "ml.c5.xlarge" # Choose an instance type that uses an Intel CPU
    initial_variant_weight = 1
    model_name             = aws_sagemaker_model.example_model.name
  }
}

# Define the SageMaker model
resource "aws_sagemaker_model" "example_model" {
  name       = "example-model"
  execution_role_arn = aws_iam_role.example_role.arn
  primary_container {
    image        = "tensorflow/tensorflow:latest"
    model_data_source = aws_s3_bucket_object.example_model_object.arn
    environment_variables = {
      "AWS_REGION" = var.aws_region
    }
  }
}

# Define the IAM role for SageMaker
resource "aws_iam_role" "example_role" {
  name = "example-sagemaker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Define the S3 bucket object for the SageMaker model
resource "aws_s3_bucket_object" "example_model_object" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = "example_model.tar.gz"
  source = "example_model.tar.gz"
}

# Define the S3 bucket for the SageMaker model
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"
}

# Define the IAM role policy for SageMaker
resource "aws_iam_policy" "example_policy" {
  name = "example-sagemaker-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreateModel",
          "sagemaker:CreateEndpointConfig",
          "sagemaker:CreateEndpoint",
          "sagemaker:DeleteEndpoint",
          "sagemaker:DeleteEndpointConfig",
          "sagemaker:DescribeEndpointConfig",
          "sagemaker:DescribeEndpoint",
          "sagemaker:InvokeEndpoint"
        ]
        Resource = "*"
      }
    ]
  })

  # Attach the policy to the IAM role
  policy = aws_iam_policy.example_policy.arn
  role   = aws_iam_role.example_role.name
}
