AWS Multi-Tier Architecture with Terraform
Overview

This Terraform project provisions a highly available, multi-tier AWS architecture consisting of:

Custom VPC with public and private subnets across two AZs

Internet Gateway & NAT Gateway

Application Load Balancer

Auto Scaling Group using Launch Template

Bastion Host

RDS MySQL Database

S3 Bucket for ALB access logs

IAM User & policies

Secrets Manager for DB credentials

The infrastructure is modularized using Terraform modules for network, compute, database, IAM, and S3.


High-Level Architecture

                ┌────────────────────────────┐
                │        Internet Users       │
                └──────────────┬─────────────┘
                               │
                        ┌──────▼───────┐
                        │  ALB (Public) │
                        └──────┬───────┘
                               │
                 ┌─────────────▼─────────────┐
                 │   Auto Scaling Group (ASG) │
                 │   EC2 in Private Subnets   │
                 └─────────────┬─────────────┘
                               │
                        ┌──────▼───────┐
                        │  RDS MySQL    │
                        │ Private Subnet│
                        └──────────────┘

 Bastion Host (Public Subnet)
        │
        └── SSH Access → Private EC2 Instances

 Private EC2 → NAT Gateway → Internet (for updates)

 ALB Access Logs → S3 Logs Bucket
 DB Credentials → AWS Secrets Manager

Modules Structure
.
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── network/
│   ├── compute/
│   ├── db/
│   ├── iam/
│   └── s3/


Deployment Steps

terraform init
terraform validate
terraform plan
terraform apply

Destroy:

terraform destroy

Outputs:

ALB DNS Name
RDS Endpoint
VPC ID
VPC CIDR