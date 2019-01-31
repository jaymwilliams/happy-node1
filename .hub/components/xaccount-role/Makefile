.DEFAULT_GOAL := deploy

STATE_BUCKET      ?= terraform.agilestacks.com
STATE_REGION      ?= us-east-1
DOMAIN_NAME       ?= undefined
ROLE_NAME 		  ?= undefined

export AWS_DEFAULT_REGION ?= us-east-2
export TF_LOG             ?= debug
export TF_LOG_PATH        ?= $(shell pwd)/.terraform/$(DOMAIN_NAME).log
export TF_OPTS            ?= -no-color
export TF_UPDATE          ?= -update

export TF_VAR_name := $(ROLE_NAME).$(DOMAIN_NAME)

terraform ?= terraform-v0.11
TFPLAN ?= $(TF_VAR_name).tfplan

deploy: init import plan apply

init:
	@mkdir -p .terraform
	$(terraform) init -get=true $(TF_CMD_OPTS) -reconfigure -force-copy  \
		-backend=true -input=false \
		-backend-config="bucket=$(STATE_BUCKET)" \
		-backend-config="region=$(STATE_REGION)" \
		-backend-config="key=$(DOMAIN_NAME)/$(ROLE_NAME)/terraform.tfstate" \
		-backend-config="profile=$(AWS_PROFILE)"
.PHONY: init

get:
	$(terraform) get $(TF_UPDATE)
.PHONY: get

plan:
	$(terraform) plan $(TF_OPTS) -refresh=true -module-depth=-1 -out=$(TFPLAN)
.PHONY: plan

apply:
	$(terraform) apply $(TF_OPTS) -Xshadow=false $(TFPLAN)
.PHONY: apply

undeploy: init import
	$(MAKE) plan TF_OPTS=-destroy
	$(MAKE) apply
.PHONY: undeploy

clean:
	rm *.tfplan
	rm -rf .terraform
.PHONY: clean		

import:
	$(eval SHORTENED_ROLE_NAME=$(shell echo $(TF_VAR_name)_role | cut -c 0-63))
	-$(terraform) import $(TF_OPTS) aws_iam_role.application $(SHORTENED_ROLE_NAME)
	$(eval SHORTENED_POLICY_NAME=$(shell echo $(TF_VAR_name)_policy | cut -c 0-63))
	-$(terraform) import $(TF_OPTS) aws_iam_role_policy.application $(SHORTENED_ROLE_NAME):$(SHORTENED_POLICY_NAME)
.PHONY: import
	