#!make

fmt:
	@terraform fmt -recursive

lint:
	@terraform fmt -check -recursive -diff=true
	@test -z $(shell find . -type f -name '*.go' | xargs gofmt -l)
	@tflint


generate-docs: fmt lint
	@$(shell terraform-docs markdown --no-escape . > README.md)
