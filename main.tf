resource "random_id" "rid" {
  byte_length = 5
}

resource "aws_sagemaker_endpoint_configuration" "ec" {
  name = "my-endpoint-config-${random_id.rid.dec}"

  # Define Production variants here. Identifies a model that you want to host and the resources chosen to deploy
  # for hosting it.
  dynamic "production_variants" {
    iterator = production_variants
    for_each = var.endpoint_production_variants

    content {
      model_name             = lookup(production_variants.value, "model_name", var.model_name)
      instance_type          = lookup(production_variants.value, "instance_type", var.instance_type)
      initial_instance_count = lookup(production_variants.value, "initial_instance_count", var.initial_instance_count)

      variant_name           = lookup(production_variants.value, "variant_name", var.variant_name)
      accelerator_type       = lookup(production_variants.value, "accelerator_type", var.accelerator_type)
      initial_variant_weight = lookup(production_variants.value, "initial_variant_weight", var.initial_variant_weight)
    }
  }

  # Define Shadow Production variants here. Identifies a model that you want to host and the resources chosen to deploy
  # for hosting it.
  dynamic "shadow_production_variants" {
    iterator = shadow_production_variants
    for_each = var.create_shadow_variant == true ? { "flag" : "yes" } : {}

    content {
      model_name             = var.shadow_model_name
      instance_type          = var.shadow_instance_type
      initial_instance_count = var.shadow_initial_instance_count

      variant_name           = var.shadow_variant_name
      accelerator_type       = var.shadow_accelerator_type
      initial_variant_weight = var.shadow_initial_variant_weight
    }
  }

  # Define the encryption key here. Encrypt your response output in S3. Choose an existing KMS key or enter a 
  # key's ARN.
  kms_key_arn = var.kms_key_arn

  # Define data capture configurations
  dynamic "data_capture_config" {
    iterator = data_capture_config
    for_each = var.enable_capture == true ? { "flag" : "yes" } : {}

    content {
      initial_sampling_percentage = var.initial_sampling_percentage
      destination_s3_uri          = var.destination_s3_uri

      capture_options {
        capture_mode = var.capture_mode
      }

      capture_content_type_header {
        json_content_types = var.json_content_types
      }
    }
  }

  # Tags to assign to endpoint configuration resource

  tags = var.tags
}