BATS ?= $(shell which bats)

.PHONY: test test-binaries test-linux test-nonlinux

test: test-binaries
	sudo $(BATS) .

test-binaries: test-linux test-nonlinux

test-linux:
	go build -o $@

test-nonlinux:
	CGO_ENABLED=0 go build -o $@


