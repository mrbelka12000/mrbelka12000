.PHONY: help build run stop clean logs test dev

help: ## Show this help message
	@echo "Portfolio Website - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build Docker image
	@echo "🏗️  Building Docker image..."
	docker build -f Dockerfile -t portfolio-website:latest .
	@echo "✅ Build complete!"

run: ## Run container with docker-compose
	@echo "🚀 Starting container..."
	docker compose -f build/docker-compose.yml up -d
	@echo "✅ Container running at http://localhost:3000"

stop: ## Stop container
	@echo "🛑 Stopping container..."
	docker compose -f build/docker-compose.yml down
	@echo "✅ Container stopped"

restart: ## Restart container
	@echo "🔄 Restarting container..."
	docker compose -f build/docker-compose.yml restart
	@echo "✅ Container restarted"

logs: ## View container logs
	docker compose -f build/docker-compose.yml logs -f

test: ## Test the build locally
	@echo "🧪 Testing build..."
	docker run --rm -p 3000:3000 portfolio-website:latest

dev: ## Run in development mode (without Docker)
	@echo "🔧 Starting development server..."
	npm run dev

clean: ## Remove containers and images
	@echo "🧹 Cleaning up..."
	docker compose -f build/docker-compose.yml down
	docker rmi portfolio-website:latest || true
	@echo "✅ Cleanup complete"

rebuild: ## Rebuild and restart
	@echo "🔄 Rebuilding and restarting..."
	docker compose -f build/docker-compose.yml down
	docker compose -f build/docker-compose.yml up -d --build
	@echo "✅ Rebuild complete!"

status: ## Check container status
	@echo "📊 Container status:"
	docker compose -f build/docker-compose.yml ps
	@echo ""
	@echo "📈 Health check:"
	curl -s http://localhost:3000/health | json_pp || echo "Container not running"

push: ## Build and push to Docker Hub
	@echo "📦 Building production image..."
	docker build -f Dockerfile --platform linux/amd64 -t mrbelka12000/portfolio-website:latest .
	@echo "🚀 Pushing to Docker Hub..."
	docker push mrbelka12000/portfolio-website:latest
	@echo "✅ Image pushed to Docker Hub!"
	@echo "📋 Pull on VPS: docker pull mrbelka12000/portfolio-website:latest"

login: ## Login to Docker Hub
	@echo "🔐 Logging in to Docker Hub..."
	@echo "Enter your Docker Hub credentials:"
	docker login

tag: ## Tag image with version (usage: make tag VERSION=1.0.0)
	@if [ -z "$(VERSION)" ]; then \
		echo "❌ Error: VERSION not specified"; \
		echo "Usage: make tag VERSION=1.0.0"; \
		exit 1; \
	fi
	@echo "🏷️  Tagging image as version $(VERSION)..."
	docker tag mrbelka12000/portfolio-website:latest mrbelka12000/portfolio-website:$(VERSION)
	docker push mrbelka12000/portfolio-website:$(VERSION)
	@echo "✅ Tagged and pushed version $(VERSION)"
