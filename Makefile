.PHONY: help bootstrap lint test tf-plan tf-apply build deploy clean

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Initialize project dependencies and Terraform
	@echo "🚀 Bootstrapping FieldOps Support AI..."
	cd infra && terraform init
	@echo "✅ Bootstrap complete"

lint: ## Run linting and formatting checks
	@echo "🔍 Running linting checks..."
	cd infra && terraform fmt -check=true -recursive
	cd infra && terraform validate
	@echo "✅ Linting complete"

test: ## Run all tests
	@echo "🧪 Running tests..."
	@echo "TODO: Implement unit tests"
	@echo "TODO: Implement contract tests"
	@echo "TODO: Implement e2e tests"
	@echo "✅ Tests complete"

tf-plan: ## Run Terraform plan for dev environment
	@echo "📋 Running Terraform plan..."
	cd infra && terraform fmt
	cd infra && terraform validate
	cd infra && terraform workspace select dev || terraform workspace new dev
	cd infra && terraform plan -var-file=envs/dev/main.tfvars
	@echo "✅ Plan complete"

tf-apply: ## Apply Terraform changes to dev environment
	@echo "🚀 Applying Terraform changes..."
	cd infra && terraform workspace select dev || terraform workspace new dev
	cd infra && terraform apply -var-file=envs/dev/main.tfvars
	@echo "✅ Apply complete"

tf-destroy: ## Destroy Terraform resources in dev environment
	@echo "💥 Destroying Terraform resources..."
	cd infra && terraform workspace select dev
	cd infra && terraform destroy -var-file=envs/dev/main.tfvars
	@echo "✅ Destroy complete"

build: ## Build application artifacts
	@echo "🔨 Building application..."
	@echo "TODO: Implement build process"
	@echo "✅ Build complete"

deploy: ## Deploy to Azure
	@echo "🚀 Deploying to Azure..."
	@echo "TODO: Implement deployment process"
	@echo "✅ Deploy complete"

clean: ## Clean up temporary files
	@echo "🧹 Cleaning up..."
	find . -name "*.tfstate.backup" -delete
	find . -name ".terraform.lock.hcl" -delete
	@echo "✅ Clean complete"
