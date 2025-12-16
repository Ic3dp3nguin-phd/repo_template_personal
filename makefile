.PHONY: setup install install-test install-prod test test-failed check clean clean-venv bump help

.DEFAULT_GOAL := help

# Auto-detect project name from current directory
# Converts kebab-case to snake_case (e.g., churn-prediction-module -> churn_prediction_module)
REPO_NAME := $(shell basename $(CURDIR))
PROJECT_NAME := $(shell echo $(REPO_NAME) | tr '-' '_')

setup: ## Initialize project structure and environment
	@echo "Auto-detected from folder: $(REPO_NAME)"
	@echo "Python package name: $(PROJECT_NAME)"
	@echo ""
	
	@echo "📁 Creating directories..."
	@mkdir -p src/$(PROJECT_NAME)
	@mkdir -p tests
	@mkdir -p scripts
	@mkdir -p docs
	@mkdir -p .github/workflows
	
	@echo "📝 Creating __init__.py files..."
	@touch src/$(PROJECT_NAME)/__init__.py
	@touch tests/__init__.py
	
	@echo "📄 Creating example script..."
	@echo '#!/usr/bin/env python3' > scripts/example_script.py
	@echo '"""Example script for $(PROJECT_NAME)."""' >> scripts/example_script.py
	@echo '' >> scripts/example_script.py
	@echo 'def main():' >> scripts/example_script.py
	@echo '    print("Hello from $(PROJECT_NAME)!")' >> scripts/example_script.py
	@echo '' >> scripts/example_script.py
	@echo 'if __name__ == "__main__":' >> scripts/example_script.py
	@echo '    main()' >> scripts/example_script.py
	@chmod +x scripts/example_script.py
	
	@echo "📦 Creating pyproject.toml..."
	@echo '[project]' > pyproject.toml
	@echo 'name = "$(PROJECT_NAME)"' >> pyproject.toml
	@echo 'version = "0.1.0"' >> pyproject.toml
	@echo 'description = "A Python project"' >> pyproject.toml
	@echo 'readme = "README.md"' >> pyproject.toml
	@echo 'requires-python = ">=3.9"' >> pyproject.toml
	@echo 'authors = [' >> pyproject.toml
	@echo '    {name = "Your Name", email = "your.email@example.com"}' >> pyproject.toml
	@echo ']' >> pyproject.toml
	@echo 'dependencies = []' >> pyproject.toml
	@echo '' >> pyproject.toml
	@echo '[project.optional-dependencies]' >> pyproject.toml
	@echo '# Test dependencies - minimal set for CI/CD pipelines' >> pyproject.toml
	@echo 'test = [' >> pyproject.toml
	@echo '    "pytest>=7.0.0",' >> pyproject.toml
	@echo '    "pytest-cov>=4.0.0",' >> pyproject.toml
	@echo ']' >> pyproject.toml
	@echo '# Dev dependencies - full toolset for local development' >> pyproject.toml
	@echo 'dev = [' >> pyproject.toml
	@echo '    "pytest>=7.0.0",' >> pyproject.toml
	@echo '    "pytest-cov>=4.0.0",' >> pyproject.toml
	@echo '    "ruff>=0.1.0",' >> pyproject.toml
	@echo '    "mypy>=1.0.0",' >> pyproject.toml
	@echo ']' >> pyproject.toml
	@echo '' >> pyproject.toml
	@echo '[build-system]' >> pyproject.toml
	@echo 'requires = ["hatchling"]' >> pyproject.toml
	@echo 'build-backend = "hatchling.build"' >> pyproject.toml
	@echo '' >> pyproject.toml
	@echo '[tool.ruff]' >> pyproject.toml
	@echo 'line-length = 88' >> pyproject.toml
	@echo 'target-version = "py39"' >> pyproject.toml
	@echo '' >> pyproject.toml
	@echo '[tool.pytest.ini_options]' >> pyproject.toml
	@echo 'testpaths = ["tests"]' >> pyproject.toml
	@echo 'python_files = ["test_*.py"]' >> pyproject.toml
	@echo '' >> pyproject.toml
	@echo '[tool.mypy]' >> pyproject.toml
	@echo 'python_version = "3.9"' >> pyproject.toml
	@echo 'warn_return_any = true' >> pyproject.toml
	@echo 'warn_unused_configs = true' >> pyproject.toml
	@echo 'disallow_untyped_defs = true' >> pyproject.toml
	@echo '' >> pyproject.toml
	@echo '[tool.commitizen]' >> pyproject.toml
	@echo 'name = "cz_conventional_commits"' >> pyproject.toml
	@echo 'version = "0.1.0"' >> pyproject.toml
	@echo 'tag_format = "v$$version"' >> pyproject.toml
	@echo 'version_files = [' >> pyproject.toml
	@echo '    "pyproject.toml:version"' >> pyproject.toml
	@echo ']' >> pyproject.toml
	
	@echo "🪝 Creating .pre-commit-config.yaml..."
	@echo 'repos:' > .pre-commit-config.yaml
	@echo '  # Basic file checks' >> .pre-commit-config.yaml
	@echo '  - repo: https://github.com/pre-commit/pre-commit-hooks' >> .pre-commit-config.yaml
	@echo '    rev: v4.5.0' >> .pre-commit-config.yaml
	@echo '    hooks:' >> .pre-commit-config.yaml
	@echo '      - id: trailing-whitespace' >> .pre-commit-config.yaml
	@echo '      - id: end-of-file-fixer' >> .pre-commit-config.yaml
	@echo '      - id: check-yaml' >> .pre-commit-config.yaml
	@echo '      - id: check-added-large-files' >> .pre-commit-config.yaml
	@echo '      - id: check-merge-conflict' >> .pre-commit-config.yaml
	@echo '      - id: check-toml' >> .pre-commit-config.yaml
	@echo '      - id: debug-statements' >> .pre-commit-config.yaml
	@echo '' >> .pre-commit-config.yaml
	@echo '  # Ruff for linting and formatting' >> .pre-commit-config.yaml
	@echo '  - repo: https://github.com/astral-sh/ruff-pre-commit' >> .pre-commit-config.yaml
	@echo '    rev: v0.1.15' >> .pre-commit-config.yaml
	@echo '    hooks:' >> .pre-commit-config.yaml
	@echo '      # Run the linter' >> .pre-commit-config.yaml
	@echo '      - id: ruff' >> .pre-commit-config.yaml
	@echo '        args: [ --fix ]' >> .pre-commit-config.yaml
	@echo '      # Run the formatter' >> .pre-commit-config.yaml
	@echo '      - id: ruff-format' >> .pre-commit-config.yaml
	@echo '' >> .pre-commit-config.yaml
	@echo '  # Type checking with mypy' >> .pre-commit-config.yaml
	@echo '  - repo: https://github.com/pre-commit/mirrors-mypy' >> .pre-commit-config.yaml
	@echo '    rev: v1.8.0' >> .pre-commit-config.yaml
	@echo '    hooks:' >> .pre-commit-config.yaml
	@echo '      - id: mypy' >> .pre-commit-config.yaml
	@echo '        additional_dependencies: []' >> .pre-commit-config.yaml
	@echo '        args: [--ignore-missing-imports]' >> .pre-commit-config.yaml
	@echo '' >> .pre-commit-config.yaml
	@echo '  # Commitizen for conventional commits' >> .pre-commit-config.yaml
	@echo '  - repo: https://github.com/commitizen-tools/commitizen' >> .pre-commit-config.yaml
	@echo '    rev: v3.13.0' >> .pre-commit-config.yaml
	@echo '    hooks:' >> .pre-commit-config.yaml
	@echo '      - id: commitizen' >> .pre-commit-config.yaml
	@echo '        stages: [commit-msg]' >> .pre-commit-config.yaml
	
	@echo "🐍 Setting up Python environment with uv..."
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "❌ Error: uv not found. Install it with:"; \
		echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"; \
		exit 1; \
	fi
	@uv venv
	@uv pip install -e ".[dev]"
	
	@echo "🪝 Setting up pre-commit hooks..."
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit install; \
	else \
		echo "⚠️  Warning: pre-commit not found. Install it with: brew install pre-commit"; \
	fi
	
	@echo ""
	@echo "📝 Creating git commits for audit trail..."
	@if [ -d .git ]; then \
		git add src/ tests/ scripts/ docs/ .github/ && \
		git commit -m "chore: initialize project structure" \
		           -m "Created by: make setup" \
		           -m "Project: $(PROJECT_NAME)" \
		           -m "Timestamp: $$(date -u +"%Y-%m-%d %H:%M:%S UTC")" \
		           -m "- src/$(PROJECT_NAME)/" \
		           -m "- tests/" \
		           -m "- scripts/" \
		           -m "- docs/" || true; \
		git add pyproject.toml .pre-commit-config.yaml && \
		git commit -m "chore: add project configuration" \
		           -m "Created by: make setup" \
		           -m "Project: $(PROJECT_NAME)" \
		           -m "Configuration files:" \
		           -m "- pyproject.toml (dependencies and tool config)" \
		           -m "- .pre-commit-config.yaml (code quality hooks)" \
		           -m "Dependencies:" \
		           -m "- Runtime: none yet" \
		           -m "- Test: pytest, pytest-cov" \
		           -m "- Dev: pytest, pytest-cov, ruff, mypy" \
		           -m "Pre-commit hooks:" \
		           -m "- Basic file checks" \
		           -m "- Ruff (linting + formatting)" \
		           -m "- Mypy (type checking)" \
		           -m "- Commitizen (conventional commits)" || true; \
		echo "✅ Git commits created"; \
		echo ""; \
		echo "📤 Pushing to remote..."; \
		if git remote | grep -q .; then \
			git push && echo "✅ Pushed to remote successfully" || echo "⚠️  Push failed - you may need to push manually"; \
		else \
			echo "⚠️  No remote configured - skipping push"; \
		fi; \
	else \
		echo "⚠️  No git repository found - skipping commits and push"; \
		echo "   Run 'git init' first if you want commit tracking"; \
	fi
	
	@echo ""
	@echo "✨ Setup complete!"
	@echo ""
	@echo "📋 Project: $(PROJECT_NAME)"
	@echo "📂 Structure:"
	@echo "   src/$(PROJECT_NAME)/"
	@echo "   tests/"
	@echo "   scripts/"
	@echo "   docs/"
	@echo ""
	@echo "🚀 Next steps:"
	@echo "   1. Activate virtual environment:"
	@echo "      • Terminal: source .venv/bin/activate"
	@echo "      • VS Code: Cmd/Ctrl+Shift+P → 'Python: Select Interpreter' → .venv"
	@echo "   2. Update pyproject.toml with your details"
	@echo "   3. Start coding in src/$(PROJECT_NAME)/"
	@echo "   4. Run 'make help' to see all available commands"

install: ## Install package with dev dependencies (local development)
	@echo "Installing package with dev dependencies..."
	@uv pip install -e ".[dev]"

install-test: ## Install package with test dependencies (CI/testing)
	@echo "Installing package with test dependencies..."
	@uv pip install -e ".[test]"

install-prod: ## Install package without dev/test dependencies (production)
	@echo "Installing package (production mode)..."
	@uv pip install -e .

test: ## Run tests with coverage
	@echo "Running tests with coverage..."
	@pytest tests/ -v --cov=src --cov-report=term-missing

test-failed: ## Run only previously failed tests
	@echo "Running failed tests..."
	@pytest tests/ --lf -v

check: ## Run linting, formatting, and tests
	@echo "Running linting checks..."
	@ruff check src/ tests/
	@mypy src/
	@echo ""
	@echo "Running auto-formatting..."
	@ruff format src/ tests/
	@ruff check --fix src/ tests/
	@echo ""
	@echo "Running tests with coverage..."
	@pytest tests/ -v --cov=src --cov-report=term-missing
	@echo ""
	@echo "✅ All checks passed!"

clean: ## Remove build artifacts and cache files
	@echo "Cleaning up..."
	@rm -rf build/ dist/ *.egg-info .pytest_cache/ .coverage htmlcov/ .mypy_cache/ .ruff_cache/
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete
	@echo "Clean complete!"

clean-venv: ## Remove virtual environment
	@echo "Removing virtual environment..."
	@rm -rf .venv/
	@echo "Virtual environment removed. Run 'make setup' to recreate."

bump: ## Bump version and update changelog using commitizen
	@cz bump --changelog

help: ## Show this help message
	@echo "Python Template - Makefile Commands"
	@echo ""
	@echo "Auto-detected project: $(PROJECT_NAME) (from folder: $(REPO_NAME))"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Setup:"
	@echo "  make setup  - Initialize project structure (auto-detects name from folder)"
	@echo ""
	@echo "Available targets:"
	@echo "  setup                Initialize project structure and environment"
	@echo "  install              Install package with dev dependencies"
	@echo "  install-test         Install package with test dependencies (CI/testing)"
	@echo "  install-prod         Install package without dev/test dependencies"
	@echo "  test                 Run tests with coverage"
	@echo "  test-failed          Run only previously failed tests"
	@echo "  check                Run linting, formatting, and tests"
	@echo "  clean                Remove build artifacts and cache files"
	@echo "  clean-venv           Remove virtual environment"
	@echo "  bump                 Bump version and update changelog using commitizen"
	@echo "  help                 Show this help message"