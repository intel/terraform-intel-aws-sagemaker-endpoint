resource "random_id" "rid" {
  byte_length = 5
}

resource "aws_sagemaker_endpoint_configuration" "ec" {
  name = "my-endpoint-config-${random_id.rid.dec}"

  production_variants {
    variant_name           = "variant-1"
    model_name             = var.model_name
    initial_instance_count = 1
    instance_type          = var.instance_type
  }

  tags = var.tags
}