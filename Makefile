.PHONY: help bootstrap lint test tf-plan tf-apply build deploy clean monitor-up monitor-down monitor-logs seed

# Default target
help: ## Show this help message
	@echo "FieldOps Support AI - Development Commands"
	@echo "=========================================="
	@echo ""
	@echo "Infrastructure:"
	@grep -E '^(bootstrap|tf-|lint|test|build|deploy|clean):.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Monitoring Stack:"
	@grep -E '^(monitor-|seed):.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

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

# Monitoring Stack Commands
monitor-up: ## Start the monitoring stack
	@echo "🔄 Starting FieldOps monitoring stack..."
	@chmod +x scripts/*.sh
	@docker-compose up -d
	@echo "✅ Stack started successfully!"
	@echo "📊 Access points:"
	@echo "   Grafana:      http://localhost:3000 (admin/admin)"
	@echo "   Prometheus:   http://localhost:9090" 
	@echo "   Alertmanager: http://localhost:9093"
	@echo "   Custom Metrics: http://localhost:9105/metrics"

monitor-down: ## Stop the monitoring stack
	@echo "🛑 Stopping FieldOps monitoring stack..."
	@docker-compose down
	@echo "✅ Stack stopped successfully!"

monitor-logs: ## Show logs from monitoring services
	@docker-compose logs -f

monitor-restart: monitor-down monitor-up ## Restart the monitoring stack

monitor-status: ## Show status of monitoring services
	@echo "📊 FieldOps Monitoring Stack Status:"
	@docker-compose ps

monitor-clean: ## Clean monitoring Docker volumes and containers
	@echo "🧹 Cleaning up monitoring resources..."
	@docker-compose down -v
	@docker system prune -f
	@echo "✅ Monitoring cleanup complete!"

seed: ## Generate seed data for testing monitoring
	@echo "🌱 Generating monitoring seed data..."
	@./scripts/seed.sh

monitor-test: ## Test monitoring alerts
	@echo "🧪 Testing monitoring alerts..."
	@echo "Testing success metrics..."
	@curl -X POST "http://localhost:9105/simulate" -H "Content-Type: application/json" -d '{"status": "success", "count": 5}' || echo "Exporter not running"
	@echo "Testing failure metrics (triggers alerts)..."
	@curl -X POST "http://localhost:9105/simulate" -H "Content-Type: application/json" -d '{"status": "fail", "count": 10}' || echo "Exporter not running"
