########################
####     Intel      ####
########################

variable "instance_type" {
  type        = string
  description = "The type of instance to start."
  default     = "ml.c7i.large"
}

# Variables for Intel tags
variable "enable_intel_tags" {
  type        = bool
  default     = true
  description = "If true adds additional Intel tags to resources"
}

variable "intel_tags" {
  default = {
    intel-registry = "https://registry.terraform.io/namespaces/intel"
    intel-module   = "terraform-intel-aws-sagemaker-endpoint"
  }
  type        = map(string)
  description = "Intel Tags"
}

########################
####    Required    ####
########################

variable "model_name" {
  type        = string
  description = "The name of the model to use."
  default     = null
}

variable "endpoint_production_variants" {
  description = "A list of Production Variant objects, one for each model that you want to host at this endpoint."
  default     = []
}

########################
####     Other      ####
########################

variable "initial_instance_count" {
  type        = number
  description = "Initial number of instances used for auto-scaling."
  default     = 1
}

variable "variant_name" {
  type        = string
  description = "The name of the variant. If omitted, Terraform will assign a random, unique name."
  default     = null
}

variable "accelerator_type" {
  type        = string
  description = "The size of the Elastic Inference (EI) instance to use for the production variant."
  default     = null
}

variable "initial_variant_weight" {
  type        = string
  description = "Determines initial traffic distribution among all of the models that you specify in the endpoint configuration. If unspecified, it defaults to 1.0."
  default     = null
}

variable "kms_key_arn" {
  type        = string
  description = "Amazon Resource Name (ARN) of a AWS Key Management Service key that Amazon SageMaker uses to encrypt data on the storage volume attached to the ML compute instance that hosts the endpoint."
  default     = null
}

# Defining data capture configurations
variable "enable_capture" {
  type        = bool
  description = "Flag to enable data capture."
  default     = false
}

variable "initial_sampling_percentage" {
  description = "Portion of data to capture. Should be between 0 and 100."
  default     = 100
}

variable "destination_s3_uri" {
  description = "The URL for S3 location where the captured data is stored."
  default     = null
}

variable "capture_mode" {
  description = "Specifies the data to be captured. Should be one of Input or Output."
  default     = "Input"
}

variable "json_content_types" {
  description = "The JSON content type headers to capture."
  default     = null
}

#Defining shadow production variants section
variable "create_shadow_variant" {
  type        = bool
  description = "A boolean flag to determinie whether a shadow production variant will be created or not."
  default     = false
}

variable "endpoint_shadow_variants" {
  description = "Array of ProductionVariant objects. There is one for each model that you want to host at this endpoint in shadow mode with production traffic replicated from the model specified on ProductionVariants.If you use this field, you can only specify one variant for ProductionVariants and one variant for ShadowProductionVariants."
  default     = []
}

variable "shadow_instance_type" {
  type        = string
  description = "The type of instance to start."
  default     = "ml.c6i.large"
}

variable "shadow_model_name" {
  type        = string
  description = "The name of the model to use."
  default     = null
}

variable "shadow_initial_instance_count" {
  type        = number
  description = "Initial number of instances used for auto-scaling."
  default     = 1
}

variable "shadow_variant_name" {
  type        = string
  description = "The name of the variant. If omitted, Terraform will assign a random, unique name."
  default     = null
}

variable "shadow_accelerator_type" {
  type        = string
  description = "The size of the Elastic Inference (EI) instance to use for the production variant."
  default     = null
}

variable "shadow_initial_variant_weight" {
  type        = string
  description = "Determines initial traffic distribution among all of the models that you specify in the endpoint configuration. If unspecified, it defaults to 1.0."
  default     = null
}

# Defining tags for the endpoint configuration resource and endpoint resource
variable "endpoint_configuration_tags" {
  type        = map(string)
  description = "Tags for the SageMaker Endpoint Configuration resource"
  default     = null
}

variable "endpoint_tags" {
  type        = map(string)
  description = "Tags for the SageMaker Endpoint resource"
  default     = null
}