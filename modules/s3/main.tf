resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "web" {
  bucket = "${var.prefix}-web-bucket-${random_string.suffix.result}"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-web-bucket-${random_string.suffix.result}"
    }
  )
}

# S3 버킷 버전 관리
resource "aws_s3_bucket_versioning" "web" {
  bucket = aws_s3_bucket.web.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 버킷 서버 측 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "web" {
  bucket = aws_s3_bucket.web.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 버킷 공개 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "web" {
  bucket = aws_s3_bucket.web.id

  block_public_acls       = true # 퍼블릭 ACL 설정 차단
  block_public_policy     = true # 퍼블릭 ACL이 있더라도 무시
  ignore_public_acls      = true # 퍼블릭 허용 정책 추가 차단
  restrict_public_buckets = true # 퍼블릭 정책이 있어도 IAM 사용자만 접근 가능
}

# S3 버킷 정적 웹사이트 설정
resource "aws_s3_bucket_website_configuration" "web" {
  bucket = aws_s3_bucket.web.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# 정적 파일 업로드
resource "aws_s3_object" "static_files" {
  for_each = var.source_files_path != null ? fileset(var.source_files_path, "**/*.*") : []

  bucket = aws_s3_bucket.web.id
  key    = each.value
  source = "${var.source_files_path}/${each.value}"

  # 파일 확장자에 따른 content_type 설정
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")

  # 파일이 변경되었을 때만 업데이트
  etag = filemd5("${var.source_files_path}/${each.value}")
}
