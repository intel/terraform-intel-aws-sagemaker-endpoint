resource "aws_sagemaker_endpoint" "endpoint" {
  name                 = "my-endpoint"
  endpoint_config_name = module.simple_realtime_endpoint.name

  tags = {
    Name = "department1_recommendation"
  }
}

module "simple_realtime_endpoint" {
  source         = "../../"
  model_name = aws_sagemaker_model.example.name
}

resource "aws_sagemaker_model" "example" {
  name               = "my-model"
  execution_role_arn = aws_iam_role.example.arn

  primary_container {
    image = data.aws_sagemaker_prebuilt_ecr_image.test.registry_path
  }
}

resource "aws_iam_role" "example" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

data "aws_sagemaker_prebuilt_ecr_image" "test" {
  repository_name = "kmeans"
}