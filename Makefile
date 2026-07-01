ARCH := $(shell uname -m)
ifeq ($(ARCH),arm64)
    BREW_PREFIX := /opt/homebrew
else
    BREW_PREFIX := /usr/local
endif

BREW         := $(BREW_PREFIX)/bin/brew
ANSIBLE      := $(BREW_PREFIX)/bin/ansible-playbook
ANSIBLE_LINT := $(BREW_PREFIX)/bin/ansible-lint
GALAXY       := $(BREW_PREFIX)/bin/ansible-galaxy

.PHONY: install check lint bootstrap

install: bootstrap
	$(ANSIBLE) playbook.yml

check: bootstrap
	$(ANSIBLE) playbook.yml --check --diff

lint:
	$(ANSIBLE_LINT) playbook.yml

bootstrap:
	@echo "Caching sudo credentials (required for Homebrew install)..."
	@sudo -v
	@if [ ! -f "$(BREW)" ]; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@if [ ! -f "$(BREW_PREFIX)/bin/ansible" ]; then \
		echo "Installing Ansible via Homebrew..."; \
		$(BREW) install ansible; \
	fi
	@$(GALAXY) collection install -r requirements.yml --upgrade
