

<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-sagemaker-endpoint/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Amazon SageMaker Endpoint module
This module provides functionality to create a SageMaker Endpoint based on the latest 3rd gen Intel Xeon scalable processors (called Icelake) that is available in SageMaker endpoints at the time of publication of this module.

## Performance Data


<center>

#### Find all the information below plus even more by navigating our full library
#### [INTEL CLOUD PERFROMANCE DATA LIBRARY for AWS](https://www.intel.com/content/www/us/en/developer/topic-technology/cloud/library.html?f:@stm_10381_en=%5BAmazon%20Web%20Services%5D)

#

#### [Achieve up to 64% Better BERT-Large Inference Work Performances by Selecting AWS M6i Instances Featuring 3rd Gen Intel Xeon Scalable Processors](https://www.intel.com/content/www/us/en/content-details/752765/achieve-up-to-64-better-bert-large-inference-work-performances-by-selecting-aws-m6i-instances-featuring-3rd-gen-intel-xeon-scalable-processors.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/752765/achieve-up-to-64-better-bert-large-inference-work-performances-by-selecting-aws-m6i-instances-featuring-3rd-gen-intel-xeon-scalable-processors.html">
  <img src="https://github.com/intel/terraform-intel-aws-sagemaker-endpoint/blob/main/images/Image01_64vcpu_BERT.jpg?raw=true" alt="Link" width="600"/>
  </a>
</p>

#

#### [Amazon M6i Instances Featuring 3rd Gen Intel Xeon Scalable Processors Delivered up to 1.75 Times the Wide & Deep Recommender Performance](https://www.intel.com/content/www/us/en/content-details/752416/amazon-m6i-instances-featuring-3rd-gen-intel-xeon-scalable-processors-delivered-up-to-1-75-times-the-wide-deep-recommender-performance.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/752416/amazon-m6i-instances-featuring-3rd-gen-intel-xeon-scalable-processors-delivered-up-to-1-75-times-the-wide-deep-recommender-performance.html">
  <img src="https://github.com/intel/terraform-intel-aws-sagemaker-endpoint/blob/main/images/Image02_96vcpu_WIDE_DEEP.jpg?raw=true" alt="Link" width="600"/>
  </a>
</p>

#

#### [Handle Up to 2.94x the Frames per Second for ResNet50 Image Classification with AWS M6i Instances Featuring 3rd Gen Intel Xeon Scalable Processors](https://www.intel.com/content/www/us/en/content-details/753022/handle-up-to-2-94x-the-frames-per-second-for-resnet50-image-classification-with-aws-m6i-instances-featuring-3rd-gen-intel-xeon-scalable-processors.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/753022/handle-up-to-2-94x-the-frames-per-second-for-resnet50-image-classification-with-aws-m6i-instances-featuring-3rd-gen-intel-xeon-scalable-processors.html">
  <img src="https://github.com/intel/terraform-intel-aws-sagemaker-endpoint/blob/main/images/Image03_Resnet50_Image_Classification.jpg?raw=true" alt="Link" width="600"/>
  </a>
</p>

#

#### [Classify up to 1.21x the Frames per Second for ResNet50 Workloads by Choosing AWS M6i Instances with 3rd Gen Intel Xeon Scalable Processors](https://www.intel.com/content/www/us/en/content-details/752689/classify-up-to-1-21x-the-frames-per-second-for-resnet50-workloads-by-choosing-aws-m6i-instances-with-3rd-gen-intel-xeon-scalable-processors.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/752689/classify-up-to-1-21x-the-frames-per-second-for-resnet50-workloads-by-choosing-aws-m6i-instances-with-3rd-gen-intel-xeon-scalable-processors.html">
  <img src="https://github.com/intel/terraform-intel-aws-sagemaker-endpoint/blob/main/images/Image04_Resnet50_FPS.jpg?raw=true" alt="Link" width="600"/>
  </a>
</p>

#

#### [Choose AWS M6i Instances with 3rd Gen Intel Xeon Scalable Processors for Better BERT Deep Learning Performance](https://www.intel.com/content/www/us/en/content-details/753290/choose-aws-m6i-instances-with-3rd-gen-intel-xeon-scalable-processors-for-better-bert-deep-learning-performance.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/753290/choose-aws-m6i-instances-with-3rd-gen-intel-xeon-scalable-processors-for-better-bert-deep-learning-performance.html">
  <img src="https://github.com/intel/terraform-intel-aws-sagemaker-endpoint/blob/main/images/Image05_BERT_BatchSize_1.jpg?raw=true" alt="Link" width="600"/>
  </a>
</p>

#

#### [Achieve up to 6.5x the BERT Deep Learning Performance with AWS M6i Instances Enabled by 3rd Gen Intel Xeon Scalable Processors](https://www.intel.com/content/www/us/en/content-details/756228/achieve-up-to-6-5x-the-bert-deep-learning-performance-with-aws-m6i-instances-enabled-by-3rd-gen-intel-xeon-scalable-processors.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/756228/achieve-up-to-6-5x-the-bert-deep-learning-performance-with-aws-m6i-instances-enabled-by-3rd-gen-intel-xeon-scalable-processors.html">
  <img src="https://github.com/intel/terraform-intel-aws-sagemaker-endpoint/blob/main/images/Image06_BERT_BatchSize_1_GenOverGen.jpg?raw=true" alt="Link" width="600"/>
  </a>
</p>

#
</center>

## Usage

See examples folder for code ./examples/provisioned-realtime-endpoint/main.tf

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
  sagemaker_container_log_level = "20"
  sagemaker_program             = "inference.py"
  sagemaker_submit_directory    = "/opt/ml/model/code"

  # This is the place where you need to provide the S3 path to the model artifact. In this example, we are using a model
  # artifact that is created from SageMaker jumpstart pre-trained model for Scikit Learn Linear regression.
  # The S3 path for the model artifact will look like the example below.
  aws-jumpstart-inference-model-uri = "s3://sagemaker-us-east-1-<AWS_Account_Id>/sagemaker-scikit-learn-2023-04-18-20-47-27-707/model.tar.gz" # change here

  # This is the ECR registry path for the container image that is used for inferencing.
  model_image = "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3"

  enable_network_isolation = true
}

resource "random_id" "rid" {
  byte_length = 5
}

module "sagemaker_scikit_learn_model" {
  source = "../../modules"

  # Specifying SageMaker Model Primary container parameters corresponding to the production variant
  sagemaker_model_primary_container = [{
    image          = local.model_image
    model_data_url = local.aws-jumpstart-inference-model-uri
    environment = {
      "SAGEMAKER_CONTAINER_LOG_LEVEL" = local.sagemaker_container_log_level
      "SAGEMAKER_PROGRAM"             = local.sagemaker_program
      "SAGEMAKER_REGION"              = local.region
      "SAGEMAKER_SUBMIT_DIRECTORY"    = local.sagemaker_submit_directory
    }
  }]
}

module "sagemaker_endpoint" {
  source = "intel/aws-sagemaker-endpoint/intel"

  # Specifying one production variant for the SageMaker endpoint configuration
  endpoint_production_variants = [{
    model_name             = module.sagemaker_scikit_learn_model.sagemaker-model-name
    instance_type          = "ml.c6i.xlarge"
    initial_instance_count = 1
    variant_name           = "my-variant-1-${random_id.rid.dec}"
  }]
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
- The Sagemaker Endpoint resource created is a provisoned endpoint

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.60 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.60 |
| <a name="provider_random"></a> [random](#provider\_random) | ~>3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_sagemaker_endpoint.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_endpoint) | resource |
| [aws_sagemaker_endpoint_configuration.ec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_endpoint_configuration) | resource |
| [random_id.rid](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerator_type"></a> [accelerator\_type](#input\_accelerator\_type) | The size of the Elastic Inference (EI) instance to use for the production variant. | `string` | `null` | no |
| <a name="input_capture_mode"></a> [capture\_mode](#input\_capture\_mode) | Specifies the data to be captured. Should be one of Input or Output. | `string` | `"Input"` | no |
| <a name="input_create_shadow_variant"></a> [create\_shadow\_variant](#input\_create\_shadow\_variant) | A boolean flag to determinie whether a shadow production variant will be created or not. | `bool` | `false` | no |
| <a name="input_destination_s3_uri"></a> [destination\_s3\_uri](#input\_destination\_s3\_uri) | The URL for S3 location where the captured data is stored. | `any` | `null` | no |
| <a name="input_enable_capture"></a> [enable\_capture](#input\_enable\_capture) | Flag to enable data capture. | `bool` | `false` | no |
| <a name="input_enable_intel_tags"></a> [enable\_intel\_tags](#input\_enable\_intel\_tags) | If true adds additional Intel tags to resources | `bool` | `true` | no |
| <a name="input_endpoint_configuration_tags"></a> [endpoint\_configuration\_tags](#input\_endpoint\_configuration\_tags) | Tags for the SageMaker Endpoint Configuration resource | `map(string)` | `null` | no |
| <a name="input_endpoint_production_variants"></a> [endpoint\_production\_variants](#input\_endpoint\_production\_variants) | A list of Production Variant objects, one for each model that you want to host at this endpoint. | `list` | `[]` | no |
| <a name="input_endpoint_shadow_variants"></a> [endpoint\_shadow\_variants](#input\_endpoint\_shadow\_variants) | Array of ProductionVariant objects. There is one for each model that you want to host at this endpoint in shadow mode with production traffic replicated from the model specified on ProductionVariants.If you use this field, you can only specify one variant for ProductionVariants and one variant for ShadowProductionVariants. | `list` | `[]` | no |
| <a name="input_endpoint_tags"></a> [endpoint\_tags](#input\_endpoint\_tags) | Tags for the SageMaker Endpoint resource | `map(string)` | `null` | no |
| <a name="input_initial_instance_count"></a> [initial\_instance\_count](#input\_initial\_instance\_count) | Initial number of instances used for auto-scaling. | `number` | `1` | no |
| <a name="input_initial_sampling_percentage"></a> [initial\_sampling\_percentage](#input\_initial\_sampling\_percentage) | Portion of data to capture. Should be between 0 and 100. | `number` | `100` | no |
| <a name="input_initial_variant_weight"></a> [initial\_variant\_weight](#input\_initial\_variant\_weight) | Determines initial traffic distribution among all of the models that you specify in the endpoint configuration. If unspecified, it defaults to 1.0. | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to start. | `string` | `"ml.c6i.large"` | no |
| <a name="input_intel_tags"></a> [intel\_tags](#input\_intel\_tags) | Intel Tags | `map(string)` | <pre>{<br>  "intel-module": "terraform-intel-aws-sagemaker-endpoint",<br>  "intel-registry": "https://registry.terraform.io/namespaces/intel"<br>}</pre> | no |
| <a name="input_json_content_types"></a> [json\_content\_types](#input\_json\_content\_types) | The JSON content type headers to capture. | `any` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Amazon Resource Name (ARN) of a AWS Key Management Service key that Amazon SageMaker uses to encrypt data on the storage volume attached to the ML compute instance that hosts the endpoint. | `string` | `null` | no |
| <a name="input_model_name"></a> [model\_name](#input\_model\_name) | The name of the model to use. | `string` | `null` | no |
| <a name="input_shadow_accelerator_type"></a> [shadow\_accelerator\_type](#input\_shadow\_accelerator\_type) | The size of the Elastic Inference (EI) instance to use for the production variant. | `string` | `null` | no |
| <a name="input_shadow_initial_instance_count"></a> [shadow\_initial\_instance\_count](#input\_shadow\_initial\_instance\_count) | Initial number of instances used for auto-scaling. | `number` | `1` | no |
| <a name="input_shadow_initial_variant_weight"></a> [shadow\_initial\_variant\_weight](#input\_shadow\_initial\_variant\_weight) | Determines initial traffic distribution among all of the models that you specify in the endpoint configuration. If unspecified, it defaults to 1.0. | `string` | `null` | no |
| <a name="input_shadow_instance_type"></a> [shadow\_instance\_type](#input\_shadow\_instance\_type) | The type of instance to start. | `string` | `"ml.c6i.large"` | no |
| <a name="input_shadow_model_name"></a> [shadow\_model\_name](#input\_shadow\_model\_name) | The name of the model to use. | `string` | `null` | no |
| <a name="input_shadow_variant_name"></a> [shadow\_variant\_name](#input\_shadow\_variant\_name) | The name of the variant. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |
| <a name="input_variant_name"></a> [variant\_name](#input\_variant\_name) | The name of the variant. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint-arn"></a> [endpoint-arn](#output\_endpoint-arn) | The Amazon Resource Name (ARN) assigned by AWS to this endpoint |
| <a name="output_endpoint-configuration-arn"></a> [endpoint-configuration-arn](#output\_endpoint-configuration-arn) | The Amazon Resource Name (ARN) assigned by AWS to this endpoint configuration |
| <a name="output_endpoint-configuration-name"></a> [endpoint-configuration-name](#output\_endpoint-configuration-name) | The name of the endpoint configuration. |
| <a name="output_endpoint-configuration-tags_all"></a> [endpoint-configuration-tags\_all](#output\_endpoint-configuration-tags\_all) | A map of tags assigned to the endpoint configuration, including those inherited from the provider default\_tags configuration block. |
| <a name="output_endpoint-name"></a> [endpoint-name](#output\_endpoint-name) | The name of the endpoint |
<!-- END_TF_DOCS -->
