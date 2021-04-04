resource "aws_iam_role" "lambda-iam-role" {
  name = "lambda-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# this is required to allow Lambda Function to create a ENI that could reach the S3 VPC endpoint
resource "aws_iam_policy" "ec2-lamdbda-handler" {
  name = "ec2-lamdbda-handler"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:AssignPrivateIpAddresses",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:UnassignPrivateIpAddresses"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-role-policy-ec2" {
  role       = aws_iam_role.lambda-iam-role.name
  policy_arn = aws_iam_policy.ec2-lamdbda-handler.arn
}

# this is required to allow Lambda Function to call DynamoDB by using its IAM permissions
resource "aws_iam_policy" "dynamodb-lamdbda-handler" {
  name = "dynamodb-lamdbda-handler"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:BatchWriteItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-role-policy-dynamodb" {
  role       = aws_iam_role.lambda-iam-role.name
  policy_arn = aws_iam_policy.dynamodb-lamdbda-handler.arn
}
