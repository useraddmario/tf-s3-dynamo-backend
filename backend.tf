resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket

# prevents deletion of bucket
  lifecycle {
    prevent_destroy = true
  }

# versioning for revision history state files
  versioning {
    enabled = true
  }

# server-side encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# handles locks on state file
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.bucket}-${var.project}-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}