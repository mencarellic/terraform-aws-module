resource "aws_s3_bucket" "this" {
  bucket = var.bucket.name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_alias.this.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.bucket.name}"
  target_key_id = aws_kms_key.this.id
}

resource "aws_kms_key" "this" {
  description         = "Encryption for ${var.bucket.name}"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.this.json

  tags = {
    Automation = "Terraform"
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "Allow access for Key Administrators"
    principals {
      type        = "AWS"
      identifiers = var.kms.admins
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
  }

  statement {
    sid = "Allow use of the key"
    principals {
      type        = "AWS"
      identifiers = var.kms.access
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}