# AWS Lambda Function with Terraform

This is a project which intends to deploy as IaC a Lambda Function on AWS,
using Python3 with Flask for the API, API Gateway with Proxy to handle multiple endpoints and invoke the Lambda, using some authentication.

It interacts with `users` through some endpoints, and persists the data on DynamoDB which is reached internally on AWS network through a VPC endpoint.

The architecture is the following:

![architecture](./images/architecture.svg)

Locally it is possible to run the API and use a local DynamoDB as well, with docker and docker-compose by running:

```bash
docker-compose up -d
```

There are more instructions about the deployment on [deployment](./terraform/README.md)
