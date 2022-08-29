RECURSIVE_TARGETS := install test-all test-integration shellcheck

.PHONY: help $(RECURSIVE_TARGETS)

help:
	@echo "Run 'sudo make install' to install kubensenter and kubens.service."
	@echo
	@echo "Adding WRAP_SERVICES=... will also create drop-in wrappers"
	@echo "which wraps each service's ExecStart line with kubensenter:"
	@echo "  make install WRAP_SERVICES=\"k3s.service other.service\""
	@echo
	@echo "Adding ENV_SERVICES=... will also create drop-ins which set"
	@echo "$$KUBENSMNT for use with services that can enter the mount"
	@echo "namespace on their own:"
	@echo "  make install ENV_SERVICES=\"crio.service\""

$(RECURSIVE_TARGETS):
	$(MAKE) -C kubensenter $@
	$(MAKE) -C systemd $@
