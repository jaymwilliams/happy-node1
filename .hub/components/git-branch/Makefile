.DEFAULT_GOAL := deploy

SRC_DIR ?= $(realpath .)
BRANCH_NAME ?= qa
REMOTE ?= https://github.com/asibot/asibot-boot
REMOTE_WITH_TOKEN ?=
ORGANIZATION ?= 
GIT_KIND ?= github

export GIT_TOKEN ?=

ifeq ($(USER_NAME),)
	USER_NAME := SuperHub
endif
ifeq ($(USER_EMAIL),)
	USER_EMAIL := support@agilestacks.com
endif

git := git -C $(SRC_DIR)

init:
	-$(git) init
.PHONY: init

remote:
ifeq ($(GIT_KIND),bitbucket)	
	$(eval REMOTE_WITH_TOKEN=$(subst ://,://$(ORGANIZATION):$(GIT_TOKEN)@,$(REMOTE)))	
else
	$(eval REMOTE_WITH_TOKEN=$(subst ://,://x-oauth-basic:$(GIT_TOKEN)@,$(REMOTE)))
endif		
	-$(git) remote add orphan-$(BRANCH_NAME) "$(REMOTE_WITH_TOKEN)"
	-$(git) remote set-url orphan-$(BRANCH_NAME) "$(REMOTE_WITH_TOKEN)"
.PHONY: remote	

output:
	-@ echo
	-@ echo Outputs:
ifeq ($(GIT_KIND),bitbucket)		
	-@ echo link_to_branch = $(subst .git,,$(REMOTE))/src/$(BRANCH_NAME)
else
	-@ echo link_to_branch = $(subst .git,,$(REMOTE))/tree/$(BRANCH_NAME)
endif	
	-@ echo
.PHONY: output

push:
	-$(git) checkout --orphan $(BRANCH_NAME)
	$(git) add -A
	$(git) config user.name "$(USER_NAME)"
	$(git) config user.email "$(USER_EMAIL)"
	-$(git) commit -am "Initial commit to $(BRANCH_NAME)"
	-$(git) push --set-upstream orphan-$(BRANCH_NAME) $(BRANCH_NAME)
.PHONY: push

deploy: init remote push output

undeploy:init remote
	-$(git) push --set-upstream orphan-$(BRANCH_NAME) --force --delete $(BRANCH_NAME)
	rm -rf $(realpath $(SRC_DIR))/.git
.PHONY: undeploy	

