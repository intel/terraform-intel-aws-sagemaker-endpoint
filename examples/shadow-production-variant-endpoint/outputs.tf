output "endpoint-name" {
  description = "The name of the endpoint."
  value       = module.sagemaker_endpoint.endpoint-name
}

output "endpoint-arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this endpoint"
  value       = module.sagemaker_endpoint.endpoint-arn
}


output "endpoint-configuration-arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this endpoint configuration"
  value       = module.sagemaker_endpoint.endpoint-configuration-arn
}

output "endpoint-configuration-name" {
  description = "The name of the endpoint configuration."
  value       = module.sagemaker_endpoint.endpoint-configuration-name
}
