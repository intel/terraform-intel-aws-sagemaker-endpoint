

<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Amazon SageMaker Endpoint Configuration module
This module provides functionality to create a SageMaker Endpoint Configuration based on the latest 3rd gen Intel Xeon scalable processors (called Icelake) that is available in SageMaker endpoints at the time of publication of this module.

## Usage

See examples folder for code ./examples/terraform-intel-aws-sagemaker-endpoint/main.tf

Example of main.tf

```hcl
#########################################################
# Local variables, modify for your needs                #
#########################################################

# See policies.md for recommended instances
# Intel recommended instance types for SageMaker endpoint configurations

# Compute Optimized
# ml.c6i.large, ml.c6i.xlarge, ml.c6i.2xlarge, ml.c6i.4xlarge, ml.c6i.8xlarge, ml.c6i.12xlarge, ml.c6i.16xlarge, 
# ml.c6i.24xlarge, ml.c6i.32xlarge,, ml.c5.large, ml.c5.xlarge, ml.c5.2xlarge, ml.c5.4xlarge, ml.c5.9xlarge, ml.c5.18xlarge, ml.c5d.large, ml.c5d.xlarge, ml.c5d.2xlarge, ml.c5d.4xlarge, ml.c5d.9xlarge, ml.c5d.18xlarge

# General Purpose
# ml.m5.large, ml.m5.xlarge, ml.m5.2xlarge, ml.m5.4xlarge, ml.m5.12xlarge, ml.m5.24xlarge, ml.m5d.large, ml.m5d.xlarge, 
# ml.m5d.2xlarge,ml.m5d.4xlarge,, ml.m5d.12xlarge, ml.m5d.24xlarge

# Memory Optimized
# ml.r5.large, ml.r5.xlarge, ml.r5.2xlarge, ml.r5.4xlarge, ml.r5.12xlarge, ml.r5.24xlarge, ml.r5d.large, ml.r5d.xlarge, 
# ml.r5d.2xlarge, ml.r5d.4xlarge, ml.r5d.12xlarge, ml.r5d.24xlarge

# Accelerated Computing
# ml.g4dn.xlarge, ml.g4dn.2xlarge, ml.g4dn.4xlarge, ml.g4dn.8xlarge, ml.g4dn.12xlarge, ml.g4dn.16xlarge, ml.inf1.xlarge, 
# ml.inf1.2xlarge, ml.inf1.6xlarge, ml.inf1.24xlarge

locals {
  region                        = "us-east-1"
  instance_type                 = "ml.c6i.xlarge"
  initial_instance_count        = 1
  sagemaker_container_log_level = "20"
  sagemaker_program             = "inference.py"
  sagemaker_submit_directory    = "/opt/ml/model/code"

  # This is the place where you need to provide the S3 path to the model artifact. In this example, we are using a model
  # artifact that is created from SageMaker jumpstart pre-trained model for Scikit Learn Linear regression.
  # The S3 path for the model artifact will look like the example below.
  # aws-jumpstart-inference-model-uri = "s3://sagemaker-<AWS_Region>-<AWS_Account_Id>/sagemaker-<ML_Framework_ML_Lib_Timestamp>/model.tar.gz"
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
  endpoint_config_name = module.simple_realtime_endpoint.name

  tags = {
    Name = "department1_recommendation"
  }
}

module "simple_realtime_endpoint" {
  source     = "../../"
  model_name = aws_sagemaker_model.example.name

  endpoint_production_variants = [{
    instance_type          = local.instance_type
    initial_instance_count = local.initial_instance_count
    variant_name           = "my-variant-1-${random_id.rid.dec}"
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

Note that this example may create resources. Run `terraform destroy` when you don't need these resources anymore.

## Considerations  
- The Sagemaker Endpoint Configuration resource created is a provisoned endpoint

## AWS References
<b>Using the SageMaker Python SDK </b>
https://sagemaker.readthedocs.io/en/stable/overview.html#use-sagemaker-jumpstart-algorithms-with-pretrained-models

<b>Deploy a  Pre-Trained Model Directly to a SageMaker Endpoint</b>
https://sagemaker.readthedocs.io/en/stable/overview.html#use-built-in-algorithms-with-pre-trained-models-in-sagemaker-python-sdk

<b>Built-in Algorithms with pre-trained Model Table</b>
https://sagemaker.readthedocs.io/en/stable/doc_utils/pretrainedmodels.html
