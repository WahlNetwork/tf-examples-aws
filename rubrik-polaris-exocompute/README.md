# Creating a VPC and subnets for Rubrik Polaris Exocompute in AWS

_[Based on this blog post](https://wahlnetwork.com/2020/04/10/exocompute-granular-file-recovery-for-aws-resources/)_

## Details

This plan will create:

* A VPC with private and public subnets

* An Internet Gateway (IGW)

* An Elastic IP (EIP)

* A NAT Gateway

* Private Route Tables

* Public Route Tables

## Credentials

Credentials should be stored in the `user\.aws\credential` file.

Example:

```bash
mkdir -p .aws
echo "[default]" > .aws/credentials
echo "aws_access_key_id = ${{ secrets.AWS_ACCESS_KEY_ID }}" >> .aws/credentials
echo "aws_secret_access_key = ${{ secrets.AWS_SECRET_ACCESS_KEY }}" >> .aws/credentials
```