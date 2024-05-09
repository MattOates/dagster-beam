.PHONY: flink-up flink-down check-kubectl check-kubernetes

ENVIRONMENT ?= local

RED=\033[0;31m
GREEN=\033[0;32m
BLUE=\033[0;34m
YELLOW=\033[0;33m
NC=\033[0m # No Color

check-kubectl:
ifeq ($(OS),Windows_NT)
	@where kubectl >nul 2>nul || (echo -e "$(RED)🚫 kubectl not found. Please install it.$(NC)" && exit /b 1)
else
	@which kubectl > /dev/null || (echo -e "$(RED)🚫 kubectl not found. Please install it.$(NC)" && exit 1)
endif

check-kubernetes:
ifeq ($(OS),Windows_NT)
	@kubectl version >nul 2>nul || (echo -e "$(RED)🚫 Kubernetes is not running. Please start it.$(NC)" && exit /b 1)
else
	@kubectl version > /dev/null || (echo -e "$(RED)🚫 Kubernetes is not running. Please start it.$(NC)" && exit 1)
endif

flink-up: check-kubectl check-kubernetes
	@echo -e "$(BLUE)🚀 Applying kustomize overlays for $(ENVIRONMENT)...$(NC)"
	kubectl apply -k kustomize/overlays/$(ENVIRONMENT)
	@echo -e "$(GREEN)✔ done.$(NC)"

flink-down: check-kubectl check-kubernetes
	@echo -e "$(YELLOW)🧹 Deleting kustomize overlays for $(ENVIRONMENT)...$(NC)"
	kubectl delete -k kustomize/overlays/$(ENVIRONMENT)
	@echo -e "$(GREEN)✔ done.$(NC)"
