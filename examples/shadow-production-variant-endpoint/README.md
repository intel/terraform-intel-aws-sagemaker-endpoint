<p align="center">
  <img src="https://github.com/OTCShare2/terraform-intel-aws-sagemaker-endpoint/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Provisioned SageMaker Realtime Endpoint with shadow production variant

This example creates a provisioned SageMaker realtime endpoint for inference on a ml.c6i.xlarge instance which is based on 3rd gen Xeon scalable processor (called Icelake). The endpoint implements a Scikit Learn linear regression model hosted on a S3 bucket. The docker container image for the inference logic is hosted on the Elastic Container Registry (ECR) within AWS

The example also creates a shadow production variant using the same model on a ml.c6i.large instance. It is equally possible to serve a different model on the shadow variant. The idea behind the shadow production variant is to send the inference request to the production variant and the shadow production variant simultaneously to compare the relative performance and accuracy of the inference between these variants.

## Usage

**See examples folder for complete examples.**

variables.tf

```hcl
No variables needed for this example
```
main.tf
```hcl
locals {
  create_shadow_variant         = true
  region                        = "us-east-1"
  sagemaker_container_log_level = "20"
  sagemaker_program             = "inference.py"
  sagemaker_submit_directory    = "/opt/ml/model/code"

  # aws-jumpstart-inference-model-uri = "s3://sagemaker-us-east-1-<AWS_Account_Id>/sagemaker-scikit-learn-2023-04-18-20-47-27-707/model.tar.gz"
  aws-jumpstart-inference-model-uri = "s3://sagemaker-us-east-1-499974397304/sagemaker-scikit-learn-2023-04-18-20-47-27-707/model.tar.gz"

  # This is the ECR registry path for the container image that is used for inferencing.
  model_image              = "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3"
  
  enable_network_isolation = true
}

resource "random_id" "rid" {
  byte_length = 5
}

resource "aws_sagemaker_endpoint" "endpoint" {
  name                 = "my-endpoint-1-${random_id.rid.dec}"
  endpoint_config_name = module.simple_realtime_endpoint_config.endpoint-configuration-name

  tags = {
    Name = "department1_recommendation"
  }
}

module "simple_realtime_endpoint_config" {
  source                = "../../"
  create_shadow_variant = local.create_shadow_variant
  model_name            = aws_sagemaker_model.example.name
  shadow_model_name     = aws_sagemaker_model.example.name

  endpoint_production_variants = [{
    instance_type          = "ml.c6i.xlarge"
    initial_instance_count = 1
    variant_name           = "production-variant-1-${random_id.rid.dec}"
  }]

  endpoint_shadow_variants = [{
    instance_type          = "ml.c6i.large"
    initial_instance_count = 1
    variant_name           = "shadow-production-variant-1-${random_id.rid.dec}"
  }]

  tags = {
    Name = "department1_recommendation"
  }
}

resource "aws_sagemaker_model" "example" {
  name                     = "my-model-${random_id.rid.dec}"
  execution_role_arn       = aws_iam_role.example.arn
  enable_network_isolation = local.enable_network_isolation

  primary_container {
    image          = local.model_image
    model_data_url = local.aws-jumpstart-inference-model-uri
    environment = {
      "SAGEMAKER_CONTAINER_LOG_LEVEL" = local.sagemaker_container_log_level
      "SAGEMAKER_PROGRAM"             = local.sagemaker_program
      "SAGEMAKER_REGION"              = local.region
      "SAGEMAKER_SUBMIT_DIRECTORY"    = local.sagemaker_submit_directory
    }
  }
}

resource "aws_iam_role" "example" {
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [aws_iam_policy.s3_read_policy.arn]
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
```



Run Terraform

```hcl
terraform init  
terraform plan
terraform apply 
```
## Considerations
- The shadow production variant in the Sagemaker endpoint configuration was introduced in December, 2022. Make sure the version of Terraform provider for AWS is a recent version that has support for shadow production variant
- The inference endpoint is created in us-east-1 region within AWS. You can change the region by updating the region within the locals definition in the main.tf file of the example
- The production variant is hosted on a ml.c6i.xlarge instance. The shadow variant is hosted on a ml.c6i.large instance. You can change the instance types by updating the instance_type and instance_type_shadow variables within the locals definition in the main.tf file of this example
- The initial_instance_count is set to one instance. You can change the initial instance count by updating the initial_instance_count within the locals definition in the main.tf file of the example
- The model used for inference is hosted on a S3 bucket and defined under a local variable called aws-jumpstart-inference-model-uri. Before running this example, you should change the aws-jumpstart-inference-model-uri to point to the S3 bucket location hosting the model you want to serve at the endpoint
- The model image containing the inference logic is hosted on the ECR registry and defined under a local variable called model_image. Before running this example, you may need to change the model_image within locals to point to the docker container hosted in your ECR registry