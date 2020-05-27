#!make

SHELL:=bash
GENERATE_DOCS_COMMAND:=terraform-docs --sort-inputs-by-required markdown . > README.md
TRIGGERS:=$(shell find triggers -type d -maxdepth 1 -not -path 'triggers')

fmt:
	@terraform fmt -recursive

lint:
	@terraform fmt -check -recursive -diff=true
	@test -z $(shell find . -type f -name '*.go' | xargs gofmt -l)
	@tflint


generate-docs: fmt lint
	@$(GENERATE_DOCS_COMMAND)
	@find triggers -type d -maxdepth 1 -not -path 'triggers' -exec sh -c 'cd {} && terraform-docs --sort-inputs-by-required markdown . > README.md' ';'
