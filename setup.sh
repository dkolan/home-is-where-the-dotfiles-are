#!/bin/bash

set -ex

# Detect OS
OS_TYPE=$(uname -s)

# macOS vs Ubuntu installation
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS detected, use Homebrew to install
    if ! command -v ansible >/dev/null 2>&1; then
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        echo "Installing Ansible using Homebrew..."
        brew install ansible
    fi
elif [[ "$OS_TYPE" == "Linux" ]]; then
    # Ubuntu detected, use apt
    if ! command -v ansible >/dev/null 2>&1; then
        echo "Installing Ansible using apt..."
        sudo apt-get update
        sudo apt-get install -y ansible
    fi
else
    echo "Unsupported OS: $OS_TYPE"
    exit 1
fi

# Set prompt for sudo password if needed
if [ -z "$NO_BECOME_PROMPT" ]; then
    PROMPT=-K
fi

# Source environment from profile (assuming profile path is correct)
. dotfiles/profile

# Run the Ansible playbook
ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i hosts.ini -l localhost playbook.yml $PROMPT
