<p align="center">
  <img src="https://github.com/OTCShare2/terraform-intel-aws-sagemaker-endpoint/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Provisioned SageMaker Realtime Endpoint with shadow production variant

This example creates a provisioned SageMaker realtime endpoint for inference on a ml.c6i.xlarge instance which is based on 3rd gen Xeon scalable processor (called Icelake). The endpoint implements a Scikit Learn linear regression model hosted on a S3 bucket. The docker container image for the inference logic is hosted on the Elastic Container Registry (ECR) within AWS

The example also creates a shadow production variant using the same model on a ml.c6i.large instance. It is equally possible to serve a different model on the shadow variant. The idea behind the shadow production variant is to send the inference request to the production variant and the shadow production variant simultaneously to compare the relative performance and accuracy of the inference between these variants.

## Usage

**See examples folder for complete examples.**

variables.tf

```hcl
No variables needed for this example
```
main.tf
```hcl

```



Run Terraform

```hcl
terraform init  
terraform plan
terraform apply 
```
## Considerations
- The inference endpoint is created in us-east-1 region within AWS. You can change the region by updating the region within the locals definition in the main.tf file of the example
- The endpoint is hosted on a ml.c6i.xlarge instance. You can change the instance type by updating the instance_type within the locals definition in the main.tf file of the example
- The initial_instance_count is set to one instance. You can change the initial instance count by updating the initial_instance_count within the locals definition in the main.tf file of the example
- The model used for inference is hosted on a S3 bucket and defined under a local variable called aws-jumpstart-inference-model-uri. Before running this example, you should change the aws-jumpstart-inference-model-uri to point to the S3 bucket location hosting the model you want to serve at the endpoint
- The model image containing the inference logic is hosted on the ECR registry and defined under a local variable called model_image. Before running this example, you may need to change the model_image within locals to point to the docker container hosted in your ECR registry