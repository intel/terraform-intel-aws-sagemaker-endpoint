# Defining the model variables

variable "create_sagemaker_model" {
  description = "Enable sagemaker model usage"
  default     = true
}

variable "sagemaker_model_enable_network_isolation" {
  description = "(Optional) - Isolates the model container. No inbound or outbound network calls can be made to or from the model container."
  default     = true
}

variable "sagemaker_model_primary_container" {
  description = "(Optional) The primary docker image containing inference code that is used when the model is deployed for predictions. If not specified, the container argument is required. "
  default     = []
}

variable "sagemaker_model_container" {
  description = "(Optional) - Specifies containers in the inference pipeline. If not specified, the primary_container argument is required."
  default     = []
}

variable "sagemaker_model_vpc_config" {
  description = "(Optional) - Specifies the VPC that you want your model to connect to. VpcConfig is used in hosting services and in batch transform."
  default     = []
}

variable "model_tags" {
  type        = map(string)
  description = "Tags for the SageMaker Model resource"
  default     = null
}