resource "aws_security_group" "lambda-function-sg" {
  description = "Security group which allows traffic to lambda function"
  vpc_id      = aws_vpc.main-vpc.id
  name        = "lambda-function-sg"

  # outbound rules
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # there is no inbound rules
  # ingress {}

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.main-vpc]
}
