<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-sagemaker-endpoint/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2024, Intel Corporation

## Provisioned SageMaker Realtime Endpoint with shadow production variant

This example creates a provisioned SageMaker realtime endpoint for inference on a ml.c7i.xlarge instance which is based on 4th gen Xeon scalable processor (called Sapphire Rapids). The endpoint implements a Scikit Learn linear regression model hosted on a S3 bucket. The docker container image for the inference logic is hosted on the Elastic Container Registry (ECR) within AWS

The example also creates a shadow production variant using the same model on a ml.c7i.large instance. It is equally possible to serve a different model on the shadow variant. The idea behind the shadow production variant is to send the inference request to the production variant and the shadow production variant simultaneously to compare the relative performance and accuracy of the inference between these variants.

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

  # This is the place where you need to provide the S3 path to the model artifact. In this example, we are using a model
  # artifact that is created from SageMaker jumpstart pre-trained model for Scikit Learn Linear regression.
  # The S3 path for the model artifact will look like the example below.
  aws-jumpstart-inference-model-uri = "s3://sagemaker-us-east-1-<AWS_Account_Id>/sklearn-regression-linear-20240208-220732/model.tar.gz" # Change here

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
  source                = "intel/aws-sagemaker-endpoint/intel"
  create_shadow_variant = local.create_shadow_variant

  endpoint_production_variants = [{
    model_name             = module.sagemaker_scikit_learn_model.sagemaker-model-name
    instance_type          = "ml.c7i.xlarge"
    initial_instance_count = 1
    variant_name           = "production-variant-1-${random_id.rid.dec}"
  }]

  endpoint_shadow_variants = [{
    model_name             = module.sagemaker_scikit_learn_model.sagemaker-model-name
    instance_type          = "ml.c7i.large"
    initial_instance_count = 1
    variant_name           = "shadow-production-variant-1-${random_id.rid.dec}"
  }]
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
- The production variant is hosted on a ml.c7i.xlarge instance. The shadow variant is hosted on a ml.c7i.large instance. You can change the instance types by updating the instance_type and instance_type_shadow variables within the locals definition in the main.tf file of this example
- The initial_instance_count is set to one instance. You can change the initial instance count by updating the initial_instance_count within the locals definition in the main.tf file of the example
- The model used for inference is hosted on a S3 bucket and defined under a local variable called aws-jumpstart-inference-model-uri. Before running this example, you should change the aws-jumpstart-inference-model-uri to point to the S3 bucket location hosting the model you want to serve at the endpoint
- The model image containing the inference logic is hosted on the ECR registry and defined under a local variable called model_image. Before running this example, you may need to change the model_image within locals to point to the docker container hosted in your ECR registry