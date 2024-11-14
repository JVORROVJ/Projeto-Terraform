resource "aws_cloudfront_origin_access_identity" "s3_origin_access" {
  comment = "Identidade de acesso para S3 bucket"
}

resource "aws_cloudfront_distribution" "hehefatcat_distribution" {
  origin {
    domain_name = aws_lb.hehefatcat.dns_name
    origin_id   = "hehefatcat-lb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = aws_s3_bucket.hehefatcat.bucket_regional_domain_name
    origin_id   = "S3-hehefatcat"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_origin_access.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Distribuição do CloudFront para ALB e S3 permitindo HTTP e HTTPS"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "hehefatcat-lb-origin"
    viewer_protocol_policy = "allow-all" # Permite HTTP e HTTPS para ALB
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      headers      = ["Host"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Comportamento do cache para bucket S3
  ordered_cache_behavior {
    path_pattern           = "/assets/*"  # Ajuste conforme necessário para o caminho S3
    target_origin_id       = "S3-hehefatcat"
    viewer_protocol_policy = "allow-all" # Permite HTTP e HTTPS para S3
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  tags = {
    Name        = "hehefatcat-cloudfront-distribution"
    Environment = "Dev"
    Managed_by  = "terraform"
  }

  wait_for_deployment = false
}