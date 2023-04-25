output "endpoint-name" {
  description = "The name of the endpoint."
  value       = aws_sagemaker_endpoint.endpoint.name
}

output "endpoint-arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this endpoint"
  value       = aws_sagemaker_endpoint.endpoint.arn
}


output "endpoint-configuration-arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this endpoint configuration"
  value       = module.simple_realtime_endpoint_config.endpoint-configuration-arn
}

output "endpoint-configuration-name" {
  description = "The name of the endpoint configuration."
  value       = module.simple_realtime_endpoint_config.endpoint-configuration-name
}
