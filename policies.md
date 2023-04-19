<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform  

© Copyright 2022, Intel Corporation

## HashiCorp Sentinel Policies

This file documents the HashiCorp Sentinel policies that apply to this module for SageMaker Endpoint Configuration

## Policy 1

Description: The SageMaker Endpoint Configuration creates an endpoint configuration that SageMaker hosting services uses to deploy models. In the configuration, you identify one or more models to deploy and the resources that you want SageMaker to provision. More details on SageMake Endpoint Configuration can be found here - https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateEndpointConfig.html.

In this policy, we will provide Intel recommendations for creating the SageMaker Endpoint Configuration for real time inference on the latest Intel Xeon Scalable Processors. Within each of the instance family types, the recommendation will be to use the latest Intel Xeon scalable processor available. We also include one prior generation of Intel Xeon within each instance family where latest is not aavilable. More information on all CPU types supported for SageMaker Endpoint for all AWS regions can be found in this link - https://aws.amazon.com/sagemaker/pricing/

Resource type:  
aws_sagemaker_endpoint_configuration

Parameter:
instance_type

Allowed Types :  Intel recommended instance types for SageMaker endpoint configurations
#### Compute Optimized
ml.c6i.large, ml.c6i.xlarge, ml.c6i.2xlarge, ml.c6i.4xlarge, ml.c6i.8xlarge, ml.c6i.12xlarge, ml.c6i.16xlarge, ml.c6i.24xlarge, ml.c6i.32xlarge,, ml.c5.large, ml.c5.xlarge, ml.c5.2xlarge, ml.c5.4xlarge, ml.c5.9xlarge, ml.c5.18xlarge, ml.c5d.large, ml.c5d.xlarge, ml.c5d.2xlarge, ml.c5d.4xlarge, ml.c5d.9xlarge, ml.c5d.18xlarge

#### General Purpose
ml.m5.large, ml.m5.xlarge, ml.m5.2xlarge, ml.m5.4xlarge, ml.m5.12xlarge, ml.m5.24xlarge, ml.m5d.large, ml.m5d.xlarge, ml.m5d.2xlarge,ml.m5d.4xlarge,, ml.m5d.12xlarge, ml.m5d.24xlarge

#### Memory Optimized
ml.r5.large, ml.r5.xlarge, ml.r5.2xlarge, ml.r5.4xlarge, ml.r5.12xlarge, ml.r5.24xlarge, ml.r5d.large, ml.r5d.xlarge, ml.r5d.2xlarge, ml.r5d.4xlarge, ml.r5d.12xlarge, ml.r5d.24xlarge

#### Accelerated Computing
ml.g4dn.xlarge, ml.g4dn.2xlarge, ml.g4dn.4xlarge, ml.g4dn.8xlarge, ml.g4dn.12xlarge, ml.g4dn.16xlarge, ml.inf1.xlarge, ml.inf1.2xlarge, ml.inf1.6xlarge, ml.inf1.24xlarge
