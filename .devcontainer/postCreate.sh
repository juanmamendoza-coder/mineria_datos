#!/bin/bash

set -e

echo "Setting up development environment..."

# Install uv if not present
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Install Just command runner
if ! command -v just &> /dev/null; then
    echo "Installing Just..."
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin
fi

# Sync Python dependencies
echo "Installing Python dependencies..."
uv sync --locked

# Register Jupyter kernel
echo "Registering Jupyter kernel..."
uv run python -m ipykernel install --user --name mineria-datos --display-name "Python 3.13 (mineria-datos)"

# Install pre-commit hooks
echo "Installing pre-commit hooks..."
uv run pre-commit install

# Create secrets baseline
if [ ! -f .secrets.baseline ]; then
    echo "Creating secrets baseline..."
    uv run detect-secrets scan > .secrets.baseline
fi

echo "✓ Development environment setup complete!"
echo ""
echo "Available commands (run 'just' to see all):"
echo "  - just preview   : Start Quarto preview server"
echo "  - just render    : Build the book"
echo "  - just lab       : Launch Jupyter Lab"
echo "  - just format    : Format all code"
echo ""
