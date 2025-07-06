# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "web" {
  name                              = "${var.prefix}-oac"
  description                       = "Origin Access Control for S3 website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront
resource "aws_cloudfront_distribution" "web" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  price_class = "PriceClass_All" # 모든 지역

  # 기본 오리진 (S3)
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.web.id
    origin_id                = "S3-${var.s3_bucket_name}"
  }

  # 기본 캐시 동작
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.s3_bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # 에러 페이지 설정
  custom_error_response {
    error_code         = 404
    response_code      = "200"
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = "200"
    response_page_path = "/index.html"
  }

  # SSL 인증서 설정
  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      # 특정 국가만 허용
      # restriction_type = "whitelist"
      # locations        = ["KR", "US", "JP"]
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-cloudfront"
    }
  )
}
