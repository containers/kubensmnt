TEST_TARGETS := test-all test-integration shellcheck

.PHONY: help install $(TEST_TARGETS)

help:
	@echo "Run 'sudo make install' to install kubensenter"

$(TEST_TARGETS):
	$(MAKE) -C test $@

install: /usr/local/bin/kubensenter

/usr/local/bin/kubensenter: kubensenter
	install --mode 0755 "$^" "$@"
