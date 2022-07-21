BATS ?= $(shell which bats)
SHELLCHECK ?= $(shell which shellcheck)

.PHONY: test-all test-integration test-binaries test-linux test-nonlinux shellcheck

test-all: shellcheck test-integration

test-integration: test-binaries
	sudo $(BATS) .

test-binaries: test-linux test-nonlinux

test-linux:
	go build -o $@

test-nonlinux:
	CGO_ENABLED=0 go build -o $@

shellcheck:
	$(SHELLCHECK) utils.sh *.bats
