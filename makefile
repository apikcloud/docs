
# Documentation Project Makefile
# ================================

# Variables
PYTHON := python3
NPM := npm
DOCSIFY := docsify
DOCS_DIR := docs
SCRIPTS_DIR := scripts
REQUIREMENTS := requirements.txt

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

# Default target
.DEFAULT_GOAL := help

# Help target
.PHONY: help
help: ## Display this help message
	@echo "$(YELLOW)Documentation Project - Available Commands:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

# Setup and Installation
.PHONY: setup
setup: ## Install all dependencies (docsify-cli and Python packages)
	@echo "$(YELLOW)Installing docsify-cli globally...$(NC)"
	sudo $(NPM) install docsify-cli -g
	@echo "$(YELLOW)Installing Python dependencies...$(NC)"
	$(PYTHON) -m pip install -r $(REQUIREMENTS) --break-system-packages
	@echo "$(GREEN)Setup completed successfully!$(NC)"

# Documentation Processing
.PHONY: aggregate
aggregate: ## Run documentation aggregation script
	@echo "$(YELLOW)Running aggregation script...$(NC)"
	@bash $(SCRIPTS_DIR)/aggregate.sh
	@echo "$(GREEN)Aggregation completed!$(NC)"

.PHONY: translate
translate: ## Run translation script
	@echo "$(YELLOW)Running translation script...$(NC)"
	$(PYTHON) $(SCRIPTS_DIR)/translate.py
	@echo "$(GREEN)Translation completed!$(NC)"

# Development Server
.PHONY: serve
serve: ## Start the docsify development server
	@echo "$(YELLOW)Starting docsify server...$(NC)"
	$(DOCSIFY) serve $(DOCS_DIR)
