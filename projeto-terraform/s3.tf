resource "aws_s3_bucket" "hehefatcat" {
  bucket = "hehefatcat-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "hehefatcat"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket" "lb_logs" {
  bucket = "hehefatcat-lb-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "hehefatcat-lb-logs"
    Environment = "${var.environment}"
  }
}