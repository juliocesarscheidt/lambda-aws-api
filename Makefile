#!/usr/bin/make

SHELL=/bin/bash

DOCKER_REPO?=juliocesarmidia/lambda-pack
DOCKER_TAG?=latest
TERRAFORM_PATH?=./terraform

deps-docker:
	@which docker

deps-terraform:
	@which terraform

build: deps-docker
	docker image build --tag $(DOCKER_REPO):$(DOCKER_TAG) \
		-f ./api/lambda.Dockerfile ./api

pack: build
	docker container run --rm -v "$$PWD/terraform/:/lambda" \
		--name lambda-pack $(DOCKER_REPO):$(DOCKER_TAG)

clean: deps-docker
	docker image rm $(DOCKER_REPO):$(DOCKER_TAG)

publish: build
	docker image push $(DOCKER_REPO):$(DOCKER_TAG)

init: deps-terraform
	cd $(TERRAFORM_PATH) && terraform init -backend=true

fmt: deps-terraform
	cd $(TERRAFORM_PATH) && terraform fmt -write=true -recursive

plan: init
	cd $(TERRAFORM_PATH) && terraform plan -input=false

validate: init
	cd $(TERRAFORM_PATH) && terraform validate

apply: validate
	cd $(TERRAFORM_PATH) && terraform apply

destroy: validate
	cd $(TERRAFORM_PATH) && terraform destroy
