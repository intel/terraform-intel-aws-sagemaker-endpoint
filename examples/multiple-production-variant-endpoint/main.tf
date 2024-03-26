#########################################################
# Local variables, modify for your needs                #
#########################################################

# See policies.md for recommended instances
# Intel recommended instance types for SageMaker endpoint configurations

# Compute Optimized
# ml.c7i.large, ml.c7i.xlarge, ml.c7i.2xlarge, ml.c7i.4xlarge, ml.c7i.8xlarge, ml.c7i.12xlarge, 
# ml.c7i.16xlarge, ml.c7i.24xlarge, ml.c7i.48xlarge, ml.c6i.large, ml.c6i.xlarge, ml.c6i.2xlarge, ml.c6i.4xlarge, ml.c6i.8xlarge, ml.c6i.12xlarge, ml.c6i.16xlarge, ml.c6i.24xlarge, ml.c6i.32xlarge


# General Purpose
# ml.m7i.large, ml.m7i.xlarge, ml.m7i.2xlarge, ml.m7i.4xlarge, ml.m7i.8xlarge, ml.m7i.12xlarge, 
# ml.m7i.16xlarge, ml.m7i.24xlarge, ml.m7i.48xlarge, ml.m5.large, ml.m5.xlarge, ml.m5.2xlarge, ml.m5.4xlarge, ml.m5.12xlarge, ml.m5.24xlarge, ml.m5d.large, ml.m5d.xlarge, ml.m5d.2xlarge,ml.m5d.4xlarge, ml.m5d.12xlarge, ml.m5d.24xlarge

# Memory Optimized
# ml.r7i.large, ml.r7i.xlarge, ml.r7i.2xlarge, ml.r7i.4xlarge, ml.r7i.8xlarge, ml.r7i.12xlarge, 
# ml.r7i.16xlarge, ml.r7i.24xlarge, ml.r7i.48xlarge, ml.r5.large, ml.r5.xlarge, ml.r5.2xlarge, ml.r5.4xlarge, ml.r5.12xlarge, ml.r5.24xlarge, ml.r5d.large, ml.r5d.xlarge, ml.r5d.2xlarge, ml.r5d.4xlarge, ml.r5d.12xlarge, ml.r5d.24xlarge

# Accelerated Computing
# ml.g4dn.xlarge, ml.g4dn.2xlarge, ml.g4dn.4xlarge, ml.g4dn.8xlarge, ml.g4dn.12xlarge, ml.g4dn.16xlarge, ml.inf1.xlarge, 
# ml.inf1.2xlarge, ml.inf1.6xlarge, ml.inf1.24xlarge

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
  aws-jumpstart-inference-model-uri_scikit_learn = "s3://sagemaker-us-east-1-<AWS_Account_Id>/sklearn-regression-linear-20240208-220732/model.tar.gz"

  # This is the place where you need to provide the S3 path to the XGBoost model artifact. This is using a model
  # artifact that is created from SageMaker jumpstart pre-trained model for XGBoost regression.
  # The S3 path for the model artifact will look like the example below.
  aws-jumpstart-inference-model-uri_xgboost = "s3://sagemaker-us-east-1-<AWS_Account_Id>/xgboost-regression-model-20240208-215820/model.tar.gz"

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
      instance_type          = "ml.c7i.xlarge"
      initial_instance_count = 1
      variant_name           = "production-variant-1-${random_id.rid.dec}"
      initial_variant_weight = 0.5
    },
    {
      model_name             = module.sagemaker_xgboost_model.sagemaker-model-name
      instance_type          = "ml.c7i.xlarge"
      initial_instance_count = 1
      variant_name           = "production-variant-2-${random_id.rid.dec}"
      initial_variant_weight = 0.5
    }
  ]
}

