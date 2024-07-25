resource "aws_s3_bucket" "live_orders_bucket" {

  bucket = var.name_bucket

  force_destroy = true

  tags = {
    Name        = "vars-env-bucket"
    Environment = "Dev"
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "acl_block_s3_access" {

  bucket = aws_s3_bucket.live_orders_bucket.id

  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "env_vars" {
  bucket = aws_s3_bucket.live_orders_bucket.bucket
  key    = "vars.env"
  source = "config/vars.env"
  acl    = "private"

  tags = {
    Name        = "vars-env-file"
    Environment = "Dev"
  }
}
