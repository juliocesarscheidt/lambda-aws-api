# this allows the Lambda Function to call S3 API Endpoints inside the AWS private network
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = aws_vpc.main-vpc.id

  route_table_ids = [aws_route_table.route-main.id]

  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "s3_endpoint"
  }

  depends_on = [aws_vpc.main-vpc, aws_route_table.route-main]
}

# this allows the Lambda Function to call DynamoDB API Endpoints inside the AWS private network
resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id = aws_vpc.main-vpc.id

  route_table_ids = [aws_route_table.route-main.id]

  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "dynamodb_endpoint"
  }

  depends_on = [aws_vpc.main-vpc, aws_route_table.route-main]
}
