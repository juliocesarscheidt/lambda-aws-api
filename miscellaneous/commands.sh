#!/bin/bash

# generate some random API token
export API_SECRET_TOKEN="$(uuidgen | sed 's/-//g')"
echo "$API_SECRET_TOKEN"
# e.g. a80ac2ff00a5468da81693a27e0c4ebf

# fixed example
export API_SECRET_TOKEN=a80ac2ff00a5468da81693a27e0c4ebf


terraform fmt -write=true -recursive
terraform init
terraform validate
terraform plan -detailed-exitcode -input=false
terraform apply -auto-approve
terraform destroy -auto-approve


######## calling API using API gateway's invoke URL
curl --silent -H "Authorization: Token $API_SECRET_TOKEN" "$(terraform output api_gateway_invoke_url)/health"
# health
# {"data":"Health"}


######## calling API using cloudfront distribution domain
curl --silent -H "Authorization: Token $API_SECRET_TOKEN" "https://$(terraform output cloudfront_domain_name)/health"
# health
# {"data":"Health"}


######## calling API using custom domain
curl --silent -H "Authorization: Token $API_SECRET_TOKEN" "https://$(terraform output api_fqdn)/health"
# health
# {"data":"Health"}
