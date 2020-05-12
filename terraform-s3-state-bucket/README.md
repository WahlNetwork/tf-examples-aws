# AWS S3 Bucket for Terraform Backend State Files

_[Based on this blog post](https://wahlnetwork.com/2020/04/29/terraform-plans-modules-and-remote-state/)_

## Details

This plan will create:

* A KMS Key to encrypt and decrypt S3 objects with an attached policy

* An alias for the KMS key

* An S3 bucket for storing Terraform state files

* A policy to block public access to the S3 bucket

## Credentials

Credentials should be stored in the `user\.aws\credential` file.

Example:

## Credentials

Credentials should be stored in the `user\.aws\credential` file using Secrets stored in this repository.

Example:

```bash
mkdir -p ~/.aws
echo "[default]" > ~/.aws/credentials
echo "aws_access_key_id = ${{ secrets.AWS_ACCESS_KEY_ID }}" >> ~/.aws/credentials
echo "aws_secret_access_key = ${{ secrets.AWS_SECRET_ACCESS_KEY }}" >> ~/.aws/credentials
```
