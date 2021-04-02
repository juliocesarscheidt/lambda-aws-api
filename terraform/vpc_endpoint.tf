# this allows the Lambda Function to call S3 API Endpoints inside the AWS private network
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = aws_vpc.main-vpc.id

  route_table_ids = [aws_route_table.route-main.id]

  service_name      = "com.amazonaws.sa-east-1.s3"
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "s3_endpoint"
  }

  depends_on = [aws_vpc.main-vpc, aws_route_table.route-main]
}
