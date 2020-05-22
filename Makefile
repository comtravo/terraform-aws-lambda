#! make

TERRAFORM_MODULES=$(shell find triggers log_subscription -type d -maxdepth 2 -not -path 'triggers' -print)
GENERATE_DOCS_COMMAND:=terraform-docs --sort-inputs-by-required markdown . > README.md

fmt:
	terraform fmt

generate-docs:
	@$(GENERATE_DOCS_COMMAND)
	@for terraform_module in $(TERRAFORM_MODULES) ; do \
			cd $$terraform_module && $(GENERATE_DOCS_COMMAND) && cd -; \
	done

