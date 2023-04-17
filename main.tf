resource "aws_sagemaker_endpoint_configuration" "ec" {
  name = "my-endpoint-config"

  production_variants {
    variant_name           = "variant-1"
    model_name             = var.model_name
    initial_instance_count = 1
    instance_type          = var.instance_type
  }

  tags = {
    Name = "department1_recommendation"
  }
}