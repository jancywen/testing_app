.PHONY: all run_dev_web run_dev_mobile run_unit clean upgrade get lint format help

all: lint format 

before_submit: format run_unit

run: get run_project

# Adding a help file: https://gist.github.com/prwhite/8168133#gistcomment-1313022
help: ## This help dialog.
	@IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
    for help_line in $${help_lines[@]}; do \
        IFS=$$'#' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf "%-30s %s\n" $$help_command $$help_info ; \
    done



clean: ## Cleans the environment
	@echo "╠ Cleaning the project..."
	@rm -rf pubspec.lock
	@flutter clean

format: ## Formats the code
	@echo "╠ Formatting the code"
	@dart format .

upgrade: clean ## Upgrades dependencies
	@echo "╠ Upgrading dependencies..."
	@flutter pub upgrade

get: clean ## Get dependencies
	@echo "╠ Get dependencies..."
	@flutter pub get

run_unit: ## Runs unit tests
	@echo "╠ Running the tests"
	@flutter test

build_dev_mobile: clean run_unit 
	@echo "╠ Building the app"
	@flutter build apk --flavor dev

run_dev_mobile: ## Runs the mobile application in dev
	@echo "╠ Running the app"
	@flutter run --flavor dev

lint: ## Lints the code
	@echo "╠ Verifying code..."
	@dart analyze . || (echo "▓▓ Lint error ▓▓"; exit 1)

run_project: ## Run Project
	@echo "╠ Run project..."
	@flutter run