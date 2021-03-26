#!/bin/bash

# docker container run --rm -it python:3.8 sh


#### docs
# https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway
# https://docs.aws.amazon.com/pt_br/lambda/latest/dg/gettingstarted-package.html#gettingstarted-package-zip
# https://docs.aws.amazon.com/pt_br/lambda/latest/dg/python-package-create.html#python-package-create-with-dependency
# https://pypi.org/project/aws-wsgi/
# https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-set-up-simple-proxy.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function


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

terraform fmt -write=true -recursive
terraform init
terraform validate
terraform plan -detailed-exitcode -input=false
terraform apply -auto-approve
terraform destroy -auto-approve


terraform output base_url
curl "$(terraform output base_url)"
curl -H "Authorization: Token APP_SECRET_TOKEN" "$(terraform output base_url)"


aws lambda invoke --function-name=ServerlessFunction --payload '{"key": "value"}' response.json
cat response.json



# sha256sum app.zip
# e6aa185559d9fb243fb149d18304314395c077e1be03646528e4c4654f7d078b  app.zip

# echo "$(sha256sum app.zip | cut -d ' ' -f 1)" | base64
# ZTZhYTE4NTU1OWQ5ZmIyNDNmYjE0OWQxODMwNDMxNDM5NWMwNzdlMWJlMDM2NDY1MjhlNGM0NjU0ZjdkMDc4Ygo=

APP_SECRET_TOKEN="$(uuidgen | sed 's/-//g')" python main.py
