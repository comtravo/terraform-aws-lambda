#!make

fmt:
	@terraform fmt -recursive

lint:
	@terraform fmt -check -recursive -diff=true
	@test -z $(shell find . -type f -name '*.go' | xargs gofmt -l)
	@tflint


generate-docs: fmt lint
	# @$(shell terraform-docs markdown --no-escape . > README.md)
	@$(shell for i in `find triggers -type d -maxdepth 2 -not -path 'triggers' -not -path '**/.terraform' -print`; do cd $i && terraform-docs markdown --no-escape . > README.md && cd -; done)
