PYTHON ?= python3
BLACK_CMD := $(PYTHON) -m black --check --diff --color .

require-extension:
	@if [ -z "$(EXTENSION)" ]; then echo "EXTENSION is required (e.g., make EXTENSION=odh-jupyter-trash-cleanup lint-ui)"; exit 1; fi

lint-dependencies:
	@$(PYTHON) -m pip install -q -r lint_requirements.txt

lint-server: require-extension lint-dependencies
	(cd $(EXTENSION) && $(PYTHON) -m flake8 .)
	@echo $(BLACK_CMD)
	@(cd $(EXTENSION) && $(BLACK_CMD)) || (echo "Black formatting encountered issues. Use 'make black-format' to fix."; exit 1)

black-format: require-extension
	(cd $(EXTENSION) && $(PYTHON) -m black .)

prettier-check-ui: require-extension
	npx --yes prettier "$(EXTENSION)/**/*{.ts,.tsx,.js,.jsx,.css,.json,.md}" --check

eslint-check-ui: require-extension
	npx --yes eslint "$(EXTENSION)" --cache --ext .ts,.tsx --max-warnings=0

prettier-ui: require-extension
	npx --yes prettier "$(EXTENSION)/**/*{.ts,.tsx,.js,.jsx,.css,.json,.md}" --write --list-different

eslint-ui: require-extension
	npx --yes eslint "$(EXTENSION)" --cache --ext .ts,.tsx --max-warnings=0 --fix

lint-ui: prettier-ui eslint-ui

lint: lint-ui lint-server ## Run linters
