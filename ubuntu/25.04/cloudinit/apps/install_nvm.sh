#!/bin/bash

if [ -z "$1" ]; then
    NVM_VERSION="v0.40.1"
else
    NVM_VERSION=$1
fi

echo "Installing NVM - $NVM_VERSION"

apt update && apt install curl -y
# INstallning NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

export NVM_DIR="$HOME/.nvm" 
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



nvm install --lts
nvm use --lts
npm install -g pnpm@latest

node -v
