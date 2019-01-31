.DEFAULT_GOAL := deploy

aws := aws
jq  := jq -r

PLATFORM_STATE_FILE   ?= should-come-from-env
PLATFORM_STATE_BUCKET ?= $(firstword $(subst /, ,$(PLATFORM_STATE_FILE:s3://%=%)))
PLATFORM_STATE_REGION ?= $(shell $(aws) s3api get-bucket-location --bucket $(PLATFORM_STATE_BUCKET) | $(jq) '.LocationConstraint//"us-east-1"')
NAMESPACE 	          ?= jenkins
DOMAIN_NAME           ?= should-be-set
APP_STATE_FILE_LOCAL  ?= hub.state
APP_STATE_FILE        ?= should-come-from-env
APP_STATE 			  ?= $(APP_STATE_FILE_LOCAL),$(APP_STATE_FILE)
APP_ELABORATE_FILE 	  ?= hub.elaborate

hub := hub -d --aws_region=$(PLATFORM_STATE_REGION) --aws_use_iam_role_credentials=false
kubectl := kubectl --context="$(DOMAIN_NAME)" --namespace="$(NAMESPACE)"

deploy:
	$(kubectl) apply -f templates/pipeline.yaml
.PHONY: deploy

undeploy:
	$(kubectl) delete -f templates/pipeline.yaml
.PHONY: undeploy

$(APP_ELABORATE_FILE):
	$(hub) elaborate hub.yaml -s $(PLATFORM_STATE_FILE) -e application.state=$(APP_ELABORATE_FILE) -o $@

install: $(APP_ELABORATE_FILE)
	$(hub) deploy $(lastword $^) -s $(APP_STATE)
.PHONY: install

uninstall: $(APP_ELABORATE_FILE)
	$(hub) undeploy $(APP_ELABORATE_FILE) -s $(APP_STATE)
.PHONY: uninstall

clean:
	rm -rf $(APP_ELABORATE_FILE) $(APP_STATE_FILE_LOCAL)
	rm -rf .git
.PHONY: clean
