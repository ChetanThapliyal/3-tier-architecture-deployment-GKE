#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl
sudo apt-get install -y git
git clone 
cd ~
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm
nvm install 21
node -v # should print `v21.7.3`
npm -v # should print `10.5.0`