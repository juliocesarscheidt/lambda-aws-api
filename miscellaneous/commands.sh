#!/bin/bash

# creates a package folder and install dependencies
if [ ! -d ./package ]; then
  echo "Package doesn't exist, creating..."
  mkdir -p ./package
  pip install -r requirements.txt --target ./package
fi

cd ./package

# creates a .zip on the previous folder
zip -r ../api.zip .
cd ../

# give permissions to be read by group and others, besides of full permission to owner
chmod 755 main.py modules/ modules/*.py

# add the *.py file in the .zip
zip -g api.zip main.py modules/*.py

# give permissions to be read by group and others, besides of full permission to owner
chmod 755 api.zip

# moves the .zip to the terraform's folder
mv ./api.zip ../terraform/


# generate some random API token
export API_SECRET_TOKEN="$(uuidgen | sed 's/-//g')"
echo "$API_SECRET_TOKEN"
# e.g. a80ac2ff00a5468da81693a27e0c4ebf

# fixed example
export API_SECRET_TOKEN=a80ac2ff00a5468da81693a27e0c4ebf


terraform fmt -write=true -recursive
terraform init -backend=true
terraform validate
terraform show
terraform refresh
terraform plan -input=false
terraform plan -detailed-exitcode -input=false
terraform apply -auto-approve
terraform destroy -auto-approve


######## calling API using API gateway's invoke URL
curl --silent "$(terraform output api_gateway_invoke_url)/health"
# health
# {"data":"Health"}


######## calling API using cloudfront distribution domain
curl --silent "https://$(terraform output cloudfront_domain_name)/health"
# health
# {"data":"Health"}


######## calling API using custom domain
curl --silent "https://$(terraform output api_fqdn)/health"
# health
# {"data":"Health"}
