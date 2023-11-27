# Enable vim mode
# bindkey -v

# Setting PATH for Python 3.9
# The original version is saved in .zprofile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}"
# export PATH

# Setting PATH for Python 3.10
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Setting GOPATH for golang
# https://www.digitalocean.com/community/tutorials/how-to-install-go-and-set-up-a-local-programming-environment-on-macos
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Setting up private repo access for golang
# https://stackoverflow.com/questions/32232655/go-get-results-in-terminal-prompts-disabled-error-for-github-private-repo
export GOPRIVATE=github.com/thekanary/*

# Set Kanary coalminer configs dir
# JSONSCHEMA_PATH="schema.json"
# export JSONSCHEMA_PATH
# CONFIGS_DIR="/Users/matt/go/src/github.com/thekanary/config-scraper/brokers/"
# export CONFIGS_DIR
