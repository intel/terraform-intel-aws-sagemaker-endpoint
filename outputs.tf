output "endpoint-configuration-arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this endpoint configuration"
  value       = aws_sagemaker_endpoint_configuration.ec.arn
}

output "endpoint-configuration-name" {
  description = "The name of the endpoint configuration."
  value       = aws_sagemaker_endpoint_configuration.ec.name
}

output "endpoint-configuration-tags_all" {
  description = "A map of tags assigned to the endpoint configuration, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_endpoint_configuration.ec.tags_all
}