# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable vim mode
export EDITOR=vim
export GIT_EDITOR=vim
# bindkey -v
# source "$HOME/.zsh-vim-mode.plugin.zsh"

# Enable history search with up arrow
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# FZF settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Use ;; as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER=';;'
# export FZF_DEFAULT_OPTS='--height=40% --preview="cat {}" --preview-window=right:60%:wrap'
# export FZF_DEFAULT_OPTS='--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

# Aliases
alias sd='cd "$(find * -type d | fzf)"'
alias vo='vim "`fzf`"'
alias pyenv='python3 -m venv venv && source venv/bin/activate'
function mkcd() { mkdir -p $@ && cd ${@:$#}  }
# Adds "git last [n]" command: show oneline summary of last n commits
alias git='git '
alias -g last='log --oneline | head -n'


# Spellcheck for .md files.
# https://superuser.com/questions/835860/spell-check-in-the-bash-cli
# https://stackoverflow.com/questions/5567794/can-aspell-output-line-number-and-not-offset-in-pipe-mode
alias plint=lintProse $1
function lintProse() {
   for file in "$@"
   do
      proselint $file
      let count=`aspell -a < $file | egrep "^\&" | awk '{print $2}' | sort -u | wc -l | awk '{print $1}'`
      # if [ $count -eq 0 ]; then
      #    printf "\n$No spelling errors on $file\n"
      # fi
      if [ $count -gt 0 ]; then
         printf "\nSpelling error(s) in $file\n"
         echo "======================================================"
         < $file aspell list |
            while read word; do grep -on "\<$word\>" $file; done |
            sponge |
            sort -n |
            uniq
         # aspell -a < $file  | egrep "^\&" | awk '{print $2}' | sort -u
      fi
   done
}

# For Building Git
alias inflate='python -c "import sys; import zlib; print(zlib.decompress(sys.stdin.buffer.read()
))"'
export PYLE_AUTHOR_NAME="Matt Parmett"
export PYLE_AUTHOR_EMAIL="matt.parmett@gmail.com"
export PATH=$PATH:/Users/matt/iCloud/Programming/pyle/pyle/bin

# For CodeQL
export PATH=$PATH:/Users/matt/Documents/codeql
export CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE=1

# For Tailscale
alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
