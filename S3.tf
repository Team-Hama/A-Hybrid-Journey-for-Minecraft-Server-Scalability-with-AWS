resource "aws_s3_bucket" "web-bucket" {
  bucket = "hama-web-bucket-mk2"
  force_destroy = "false"
  object_lock_enabled = "false"

  tags = {
  Label        = "Hama"
  Name         = "aws-vpc"
  env          = "Hama"
  provision-by = "terraform"
  }

  tags_all = {
  Label        = "Hama"
  Name         = "aws-vpc"
  env          = "Hama"
  provision-by = "terraform"
  }

  lifecycle {
    ignore_changes = [
      versioning,      # 버전 관리 설정 변경 무시
      tags             # 태그 변경 무시
    ]
  }
}

# 퍼블릭 액세스 차단 해제
resource "aws_s3_bucket_public_access_block" "web-bucket-public-access" {
  bucket                  = aws_s3_bucket.web-bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "hama-web-bucket-policy" {
  bucket = aws_s3_bucket.web-bucket.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = "${aws_s3_bucket.web-bucket.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.web-bucket-public-access]
}
