# Terraform AWS Infrastructure Setup

This Terraform project sets up a basic AWS infrastructure including a VPC with public and private subnets, an EC2 Auto Scaling Group running NGINX, and a Route 53 A record.

## Infrastructure Components

1. **VPC Setup**:
   - Creates a VPC named `ionginx-vpc` with a /16 CIDR block.
   - Sets up 3 public and 3 private subnets across different availability zones.
   - Creates an Internet Gateway for public internet access.
   - Sets up a NAT Gateway in the public subnet for private subnet internet access.

2. **EC2 Auto Scaling Group**:
   - Launches EC2 instances using Ubuntu with NGINX installed.
   - Configures an Auto Scaling Group with a minimum of 2 and a maximum of 4 instances.
   - Instances are placed in private subnets without public IPv4 addresses for enhanced security.
   - SSH access to instances is disabled for better security posture.

3. **Route 53 A Record**:
   - Creates a Route 53 hosted zone and A record (`nginx.example.com`).
   - Points the A record to the NAT Gateway's Elastic IP address.
   - Enables NGINX to serve a default webpage accessible via the A record.

## Usage

1. **Prerequisites**:
   - Install Terraform and configure AWS credentials with appropriate permissions.

2. **Configuration**:
   - Modify `variables.tf` to adjust variables like AWS region, VPC CIDR blocks, etc., if needed.
   - Ensure the correct AMI ID is used for the Ubuntu image in `modules/ec2_autoscaling/main.tf`.

3. **Deployment**:
   - Initialize Terraform:
     ```
     terraform init
     ```
   - Plan the deployment to verify the changes:
     ```
     terraform plan
     ```
   - Apply the configuration to create the infrastructure:
     ```
     terraform apply
     ```

4. **Cleanup**:
   - To destroy the created resources:
     ```
     terraform destroy
     ```
   - Confirm destruction by typing `yes` when prompted.

