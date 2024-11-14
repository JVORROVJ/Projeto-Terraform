resource "aws_lb" "hehefatcat" {
  name               = "hehefatcat-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["fatcat_public_subnet_1", "fatcat_public_subnet_2", "fatcat_public_subnet_3"]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "hehefatcat-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "hehefatcat" {
  name     = "hehefatcat-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.fatcat_vpc.id
}

resource "aws_lb_target_group_attachment" "hehefatcat_instance_1" {
  target_group_arn = aws_lb_target_group.hehefatcat.arn               # Reference the declared target group
  target_id        = aws_instance.fatcat_private_ec2_1.id             # Attach the first instance
  port             = 80                                               # Port where the application is listening
}

resource "aws_lb_target_group_attachment" "hehefatcat_instance_2" {
  target_group_arn = aws_lb_target_group.hehefatcat.arn
  target_id        = aws_instance.fatcat_private_ec2_2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "hehefatcat_instance_3" {
  target_group_arn = aws_lb_target_group.hehefatcat.arn
  target_id        = aws_instance.fatcat_private_ec2_3.id
  port             = 80
}

resource "aws_lb_listener" "hehefatcat" {
  load_balancer_arn = aws_lb.hehefatcat.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hehefatcat.arn
  }
}