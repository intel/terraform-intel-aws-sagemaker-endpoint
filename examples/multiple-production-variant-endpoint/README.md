<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-sagemaker-endpoint/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Provisioned SageMaker Realtime Endpoint with multiple production variants

This example creates a provisioned SageMaker realtime endpoint for inference on ml.c6i.xlarge instance which is based on 3rd gen Xeon scalable processor (called Icelake). 

It implements two production variants serving two different models using traffic distribution. In this setup, 50% of the inference traffic will be sent to one of the production variants. The remaining 50% of the inference traffic will be sent to the other production variants. Customers typically use multiple production variants to evaluate the performance of different models.

The first production variant implements a Scikit Learn linear regression model where the model is hosted on a S3 bucket. The docker container image for the inference logic is hosted on the Elastic Container Registry (ECR) within AWS

The second production variant implements a XGBoost regression model where the model is hosted on a S3 bucket. The docker container image for the inference logic is hosted on the Elastic Container Registry (ECR) within AWS

## Usage

**See examples folder for complete examples.**

variables.tf

```hcl
No variables needed for this example
```
main.tf
```hcl
locals {
  region                         = "us-east-1"
  sagemaker_container_log_level  = "20"
  sagemaker_program              = "inference.py"
  sagemaker_submit_directory     = "/opt/ml/model/code"
  model_cache_root               = "/opt/ml/model"
  sagemaker_env                  = 1
  sagemaker_model_server_timeout = 3600
  sagemaker_model_server_workers = 1

  # This is the place where you need to provide the S3 path to the Scikit Learn model artifact. This is using a model
  # artifact that is created from SageMaker jumpstart pre-trained model for Scikit Learn Linear regression.
  # The S3 path for the model artifact will look like the example below.
  aws-jumpstart-inference-model-uri = "s3://sagemaker-us-east1-<AWS_Account_Id>/sagemaker-scikit-learn-2023-04-18-20-47-27-707/model.tar.gz" # Change here

  # This is the place where you need to provide the S3 path to the XGBoost model artifact. This is using a model
  # artifact that is created from SageMaker jumpstart pre-trained model for XGBoost regression.
  # The S3 path for the model artifact will look like the example below.
  aws-jumpstart-inference-model-uri_xgboost = "s3://sagemaker-us-east1-<AWS_Account_Id>/xgboost-regression-model-20230422-003939/model.tar.gz" # Change here

  # This is the ECR registry path for the container image that is used for inferencing.
  model_image_scikit_learn = "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3"
  model_image_xgboost      = "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-xgboost:1.3-1"

  enable_network_isolation = true
}

resource "random_id" "rid" {
  byte_length = 5
}

module "sagemaker_scikit_learn_model" {
  source = "../../modules"

  # Specifying SageMaker Model Primary container parameters corresponding to the production variant for Scikit Learn model
  sagemaker_model_primary_container = [
    {
      image          = local.model_image_scikit_learn
      model_data_url = local.aws-jumpstart-inference-model-uri_scikit_learn
      environment = {
        "SAGEMAKER_CONTAINER_LOG_LEVEL" = local.sagemaker_container_log_level
        "SAGEMAKER_PROGRAM"             = local.sagemaker_program
        "SAGEMAKER_REGION"              = local.region
        "SAGEMAKER_SUBMIT_DIRECTORY"    = local.sagemaker_submit_directory
      }
  }]
}

module "sagemaker_xgboost_model" {
  source = "../../modules"

  # Specifying SageMaker Model Primary container parameters corresponding to the production variant for XGBoost model
  sagemaker_model_primary_container = [
    {
      image          = local.model_image_xgboost
      model_data_url = local.aws-jumpstart-inference-model-uri_xgboost
      environment = {
        "MODEL_CACHE_ROOT"               = local.model_cache_root
        "SAGEMAKER_CONTAINER_LOG_LEVEL"  = local.sagemaker_container_log_level
        "SAGEMAKER_ENV"                  = local.sagemaker_env
        "SAGEMAKER_MODEL_SERVER_TIMEOUT" = local.sagemaker_model_server_timeout
        "SAGEMAKER_MODEL_SERVER_WORKERS" = local.sagemaker_model_server_workers
        "SAGEMAKER_PROGRAM"              = local.sagemaker_program
        "SAGEMAKER_REGION"               = local.region
        "SAGEMAKER_SUBMIT_DIRECTORY"     = local.sagemaker_submit_directory
      }
  }]
}

module "sagemaker_endpoint" {
  source = "intel/aws-sagemaker-endpoint/intel"

  # Specifying two production variants for the SageMaker endpoint configuration
  endpoint_production_variants = [
    {
      model_name             = module.sagemaker_scikit_learn_model.sagemaker-model-name
      instance_type          = "ml.c6i.xlarge"
      initial_instance_count = 1
      variant_name           = "production-variant-1-${random_id.rid.dec}"
      initial_variant_weight = 0.5
    },
    {
      model_name             = module.sagemaker_xgboost_model.sagemaker-model-name
      instance_type          = "ml.c6i.xlarge"
      initial_instance_count = 1
      variant_name           = "production-variant-2-${random_id.rid.dec}"
      initial_variant_weight = 0.5
    }
  ]
}
```

Run Terraform

```hcl
terraform init  
terraform plan
terraform apply 
```
## Considerations
- The inference endpoint is created in us-east-1 region within AWS. You can change the region by updating the region within the locals definition in the main.tf file of the example
- The endpoint is hosted on ml.c6i.xlarge instance for both the production variants. You can change the instance type by updating the instance_type within the locals definition in the main.tf file of the example
- The initial_instance_count is set to one instance. You can change the initial instance count by updating the initial_instance_count within the locals definition in the main.tf file of the example
- The two models used for inference is hosted on a S3 bucket and defined under local variables called aws-jumpstart-inference-model-uri_scikit_learn and aws-jumpstart-inference-model-uri_xgboost. Before running this example, you should change the S3 paths of the models to point to the S3 bucket locations hosting the models you want to serve at the endpoint
- The model images containing the inference logic for both scikit learn and xgboost are hosted on the ECR registry and defined under a local variables called model_image_scikit_learn and model_image_xgboost. Before running this example, you may need to change the model image ECR paths within locals to point to the docker containers hosted in your accounts's ECR registry