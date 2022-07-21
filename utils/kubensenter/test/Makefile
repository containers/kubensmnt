BATS ?= $(shell which bats)
SHELLCHECK ?= $(shell which shellcheck)

.PHONY: test-all test-integration shellcheck

test-all: shellcheck test-integration

test-integration:
	sudo $(BATS) .

shellcheck:
	$(SHELLCHECK) ../kubensenter *.bats
