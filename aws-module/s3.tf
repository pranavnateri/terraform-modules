resource "aws_s3_bucket" "s3" {
  bucket = "${local.env_selected}-${var.service_name}-${var.region}-intuitive-bucket"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket]
  bucket     = aws_s3_bucket.s3.id
  acl        = "private"
}