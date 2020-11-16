#! make

DOCKER_COMPOSE=docker-compose -f ./docker-compose.yml
DOCKER_COMPOSE_DEVELOP=$(DOCKER_COMPOSE) -f ./docker-compose.develop.yml
GENERATE_DOCS_COMMAND:=terraform-docs --sort-inputs-by-required markdown --no-escape . > README.md

fmt:
	@terraform fmt -recursive
	@find . -name '*.go' | xargs gofmt -w -s

lint:
	@terraform fmt -check -recursive -diff=true
	@test -z $(shell find . -type f -name '*.go' | xargs gofmt -l)
	@tflint

build:
	@$(DOCKER_COMPOSE) build

test-localstack:
	@cd test && go test -tags=localstack

test-all: test-localstack

test-docker:
	@$(DOCKER_COMPOSE) run --rm terraform make lint
	@$(DOCKER_COMPOSE) run --rm terraform make test-all
	@$(DOCKER_COMPOSE) down -v

develop:
	@$(DOCKER_COMPOSE_DEVELOP) run --rm terraform bash
	@$(DOCKER_COMPOSE_DEVELOP) down -v

generate-docs: fmt lint
	@$(shell $(GENERATE_DOCS_COMMAND))
	@find triggers -maxdepth 1 -type d -not -path 'triggers' -exec sh -c 'cd {} && $(GENERATE_DOCS_COMMAND)' ';'

clean-state:
	@find . -type f -name 'terraform.tfstate*' | xargs rm -rf
	@find . -type d -name '.terraform' | xargs rm -rf

clean-all: clean-state
	@$(DOCKER_COMPOSE) down -v

logs:
	@$(DOCKER_COMPOSE) logs -f

.PHONY: test
