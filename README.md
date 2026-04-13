# Terraform in Action

This repository contains Terraform configurations for demonstration and educational purposes, showcasing basic infrastructure provisioning on AWS.

## Requirements

To use these Terraform configurations, you will need:

- **Terraform CLI:** Ensure Terraform is installed on your system.
- **AWS Account & Credentials:** Configure your AWS credentials. This can be done via environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`), the AWS CLI configuration (`~/.aws/credentials`), or an IAM role.

## Usage

### 1. Initialize Terraform

Initializes a working directory containing Terraform configuration files. This step downloads the necessary providers.

```bash
terraform init
```

### 2. Create an Execution Plan

Generates an execution plan, showing what actions Terraform will take to achieve the desired state defined in your configuration.

```bash
terraform plan
```

### 3. Apply the Changes

Applies the changes required to reach the desired state of the configuration, as described in the plan.

```bash
terraform apply
```

### 4. Destroy the Infrastructure

Destroys the Terraform-managed infrastructure. **Use with caution!** This will deprovision all resources created by this configuration.

```bash
terraform destroy
```
