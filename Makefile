shell = ${SHELL}

# Meta-Goals
.PHONY: help
.DEFAULT_GOAL := help
project := adrift
entrypoint := app.py

default:
	echo 'Makefile default target!'

##@ Section 1: Local Build Commands
.PHONY: install
install: ##@repo Installs needed prerequisites and software to develop in the SRE space
	$(info ********** Installing SRE Repo Prerequisites **********)
	@brew bundle --force
	@pipx ensurepath
	@bash scripts/install.sh -a
	@bash scripts/install.sh -p
	@asdf reshim

##@ Section 2: Application Build/Deploy Commands
.PHONY: run build api-key
build: ##app Build the Application
	$(info ******** Installing the UI ********)
	@bash -c "python -m pip install --upgrade pip && python -m pip install -r requirements.txt"
	@bash -c "python -m poetry install"

run: ##app Start the UI server
	$(info ******** Running the UI ********)
	@bash -c "python -m poetry run streamlit run ${project}/${entrypoint}"

api-key: ##@app Set the API Key for the project
	$(info ********** Setting the API Key **********)
	@bash scripts/api_key_generator.sh

##@ Section 3: Encryption/Decryption Commands
.PHONY: encrypt-configs decrypt-configs
encrypt-configs: ##@encryption Encrypts the configuration files
	$(info ********** Encrypting Configuration File **********)
	@if grep -Fxq '[sops]' adrift/config.yml; then echo "Config file already encrypted"; exit 0; fi
	@sops --encrypt --in-place --encrypted-regex 'database' --pgp `gpg --fingerprint "adrift.application" | grep pub -A 1 | grep -v pub | sed s/\ //g` adrift/config.yml
	@sops --encrypt --in-place --pgp `gpg --fingerprint "adrift.application" | grep pub -A 1 | grep -v pub | sed s/\ //g` adrift/postgres.env
	@echo "[INFO] - Configuration file encrypted"

decrypt-configs: ##@encryption Decrypts the configuration files
	$(info ********** Decrypting Configuration File **********)
	@sops --decrypt --in-place --ignore-mac adrift/config.yml
	@sops --decrypt --in-place --ignore-mac adrift/postgres.env
	@echo "[INFO] - Configuration file decrypted"

create-keys: ##@encryption Creates the GPG keys for the project
	$(info ********** Creating GPG Keys **********)
	@bash scripts/encryption/create_keys.sh
	#@python scripts/encryption/post_key_setup.py

##\@ Section 4: Dockerfile Build Commands

##\@ Section 5: Documentation

### Help Section
help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
