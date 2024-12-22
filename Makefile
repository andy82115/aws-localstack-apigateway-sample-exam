SHELL := /bin/bash
PYTHON_BIN ?= $(shell which python3 || which python)

usage:       ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

docker-start:
	docker-compose up -d
	@echo "Waiting for LocalStack to be ready..."
	@until docker-compose logs | grep -q "Ready"; do sleep 1; done
	@echo "LocalStack is ready!"

docker-stop:
	@echo "Stopping LocalStack..."
	@docker-compose down
	@echo "Waiting for LocalStack to be fully stopped..."
	@while docker-compose ps | grep -q 'Up'; do sleep 1; done
	@echo "LocalStack has been stopped!"

docker-restart:
	$(MAKE) docker-stop	
	$(MAKE) docker-start

install:
	@which awslocal || pip install awscli-local
	@which terraform || (echo 'Terraform was not found';)
	@which tflocal || pip install terraform-local

tf-init:
	tflocal -chdir=stage init

tf-plan:
	tflocal -chdir=stage plan

tf-apply:
	tflocal -chdir=stage apply --auto-approve	

tf-output:
	tflocal -chdir=stage output	

tf-clean:
	tflocal -chdir=stage destroy --auto-approve	

tf-deploy:
	$(MAKE) tf-init
	$(MAKE) tf-plan
	$(MAKE) tf-apply

run:
	$(MAKE) docker-start
	$(MAKE) tf-init 
	$(MAKE) tf-plan 
	$(MAKE) tf-apply

.PHONY: docker-start docker-stop docker-restart tf-init tf-plan tf-apply tf-clean tf-deploy install run