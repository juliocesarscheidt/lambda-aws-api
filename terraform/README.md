# Deployment with Terraform

The requirements are:

- docker
- terraform

In order to deploy, first of all we need to pack the Lambda Function:

```bash
# from root directory
make pack
```

This will generate a file `api.zip` on `terraform` folder.

Then, we need to set a few variables for Terraform:

```bash
export TF_VAR_aws_access_key="AWS_ACCESS_KEY_ID"
export TF_VAR_aws_secret_key="AWS_SECRET_ACCESS_KEY"
export TF_VAR_root_domain="domain.com.br"
export TF_VAR_certificate_arn="arn:aws:acm:region:account:certificate/uuid"
export TF_VAR_api_secret_token="SOME_API_SECRET"
```

After that is possible to deploy by running:

```bash
make apply
```
