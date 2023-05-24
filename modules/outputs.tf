#---------------------------------------------------
# AWS Sagemaker model
#---------------------------------------------------
output "sagemaker-model-name" {
  description = "The name of the model."
  value       = element(concat(aws_sagemaker_model.sagemaker_model.*.name, [""]), 0)
}

output "sagemaker-model-arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this model."
  value       = element(concat(aws_sagemaker_model.sagemaker_model.*.arn, [""]), 0)
}