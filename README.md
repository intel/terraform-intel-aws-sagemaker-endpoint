

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.36.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.36.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~>3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_sagemaker_endpoint_configuration.ec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_endpoint_configuration) | resource |
| [random_id.rid](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerator_type"></a> [accelerator\_type](#input\_accelerator\_type) | The size of the Elastic Inference (EI) instance to use for the production variant. | `string` | `null` | no |
| <a name="input_capture_mode"></a> [capture\_mode](#input\_capture\_mode) | Specifies the data to be captured. Should be one of Input or Output. | `string` | `"Input"` | no |
| <a name="input_destination_s3_uri"></a> [destination\_s3\_uri](#input\_destination\_s3\_uri) | The URL for S3 location where the captured data is stored. | `any` | `null` | no |
| <a name="input_enable_capture"></a> [enable\_capture](#input\_enable\_capture) | Flag to enable data capture. | `bool` | `false` | no |
| <a name="input_endpoint_production_variants"></a> [endpoint\_production\_variants](#input\_endpoint\_production\_variants) | A list of Production Variant objects, one for each model that you want to host at this endpoint. | `list` | `[]` | no |
| <a name="input_initial_instance_count"></a> [initial\_instance\_count](#input\_initial\_instance\_count) | Initial number of instances used for auto-scaling. | `number` | `1` | no |
| <a name="input_initial_sampling_percentage"></a> [initial\_sampling\_percentage](#input\_initial\_sampling\_percentage) | Portion of data to capture. Should be between 0 and 100. | `number` | `100` | no |
| <a name="input_initial_variant_weight"></a> [initial\_variant\_weight](#input\_initial\_variant\_weight) | Determines initial traffic distribution among all of the models that you specify in the endpoint configuration. If unspecified, it defaults to 1.0. | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to start. | `string` | `"ml.c6i.large"` | no |
| <a name="input_json_content_types"></a> [json\_content\_types](#input\_json\_content\_types) | The JSON content type headers to capture. | `any` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Amazon Resource Name (ARN) of a AWS Key Management Service key that Amazon SageMaker uses to encrypt data on the storage volume attached to the ML compute instance that hosts the endpoint. | `string` | `null` | no |
| <a name="input_model_name"></a> [model\_name](#input\_model\_name) | The name of the model to use. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the SageMaker Endpoint Configuration resource | `map(string)` | n/a | yes |
| <a name="input_variant_name"></a> [variant\_name](#input\_variant\_name) | The name of the variant. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint-configuration-arn"></a> [endpoint-configuration-arn](#output\_endpoint-configuration-arn) | The Amazon Resource Name (ARN) assigned by AWS to this endpoint configuration |
| <a name="output_endpoint-configuration-name"></a> [endpoint-configuration-name](#output\_endpoint-configuration-name) | The name of the endpoint configuration. |
| <a name="output_endpoint-configuration-tags_all"></a> [endpoint-configuration-tags\_all](#output\_endpoint-configuration-tags\_all) | A map of tags assigned to the endpoint configuration, including those inherited from the provider default\_tags configuration block. |
<!-- END_TF_DOCS -->