resource "aws_security_group" "lambda-function-sg" {
  description = "security group that allows specific ports and traffic to lambda function"
  vpc_id      = aws_vpc.main-vpc.id
  name        = "lambda-function-sg"

  # outbound rules
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # inbound rules
  # ingress {
  #   from_port = 0
  #   to_port   = 0
  #   protocol  = "-1"

  #   security_groups = []
  # }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.main-vpc]
}
