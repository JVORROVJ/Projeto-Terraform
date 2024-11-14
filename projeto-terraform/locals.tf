data "aws_caller_identity" "current" {}

data "aws_cloudfront_distribution" "current" {
  id = aws_cloudfront_distribution.hehefatcat_distribution.id
}

locals {
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.hehefatcat.bucket}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${data.aws_cloudfront_distribution.current.id}"
          }
        }
      },
    ]
  })

  s3_origin_id = aws_s3_bucket.hehefatcat.id
  lb_origin    = aws_lb.hehefatcat.id
}

resource "aws_s3_bucket_policy" "hehefatcat_policy" {
  bucket = aws_s3_bucket.hehefatcat.id
  policy = local.policy
}