#!/bin/bash

# docker container run --rm -it python:3.8 sh


#### docs
# https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway
# https://docs.aws.amazon.com/pt_br/lambda/latest/dg/gettingstarted-package.html#gettingstarted-package-zip
# https://docs.aws.amazon.com/pt_br/lambda/latest/dg/python-package-create.html#python-package-create-with-dependency
# https://pypi.org/project/aws-wsgi/
# https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-set-up-simple-proxy.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function

# https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment#redeployment-triggers
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration

# https://registry.terraform.io/providers/hashicorp/aws/3.3.0/docs/resources/iam_role
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

# https://aws.amazon.com/pt/premiumsupport/knowledge-center/api-gateway-cloudfront-distribution/
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/add-origin-custom-headers.html#add-origin-custom-headers-forward-authorization
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/controlling-the-cache-key.html#cache-key-understand-cache-policy-settings


#### package

# instala pacotes em uma pasta de dependencias
pip install -r requirements.txt --target ./package
cd ./package

# cria um zip na pasta anterior
zip -r ../app.zip .
cd ../

# adiciona o main.py no zip
zip -g app.zip main.py

# permissões para ser lido
chmod 755 app.zip

# mover para a pasta do terraform
mv ./app.zip ../terraform/
cd ../terraform


#### deploy

export API_SECRET_TOKEN="$(uuidgen | sed 's/-//g')"
echo "$API_SECRET_TOKEN"


export TF_VAR_api_secret_token="$API_SECRET_TOKEN"

terraform fmt -write=true -recursive
terraform init
terraform validate
terraform plan -detailed-exitcode -input=false
terraform apply -auto-approve
terraform destroy -auto-approve


terraform output base_url
curl "$(terraform output base_url)"
# Unauthorized Access

curl --silent -H "Authorization: Token $API_SECRET_TOKEN" drgd8ntbst4bw.cloudfront.net | jq .
# {
#   "message": "OK",
#   "status": 200
# }

# health
curl --silent -H "Authorization: Token $API_SECRET_TOKEN" "https://cloud.blackdevs.com.br" | jq .
# {
#   "message": "Health",
#   "status": 200
# }


aws lambda invoke \
  --function-name=lambda-function \
  --payload '{"key": "value"}' \
  response.json

cat response.json


# sha256sum app.zip
# e6aa185559d9fb243fb149d18304314395c077e1be03646528e4c4654f7d078b  app.zip

# echo "$(sha256sum app.zip | cut -d ' ' -f 1)" | base64
# ZTZhYTE4NTU1OWQ5ZmIyNDNmYjE0OWQxODMwNDMxNDM5NWMwNzdlMWJlMDM2NDY1MjhlNGM0NjU0ZjdkMDc4Ygo=

API_SECRET_TOKEN="$(uuidgen | sed 's/-//g')" python main.py
