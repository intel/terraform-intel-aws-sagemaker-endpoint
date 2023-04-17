########################
####     Intel      ####
########################

variable "instance_type" {
  type        = string
  description = "The type of instance to start."
  default     = "ml.c6i.large"
}

########################
####    Required    ####
########################

variable "model_name" {
  type        = string
  description = "The name of the model to use."
}

########################
####     Other      ####
########################