# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable vim mode
export EDITOR=vim
bindkey -v
# source "$HOME/.zsh-vim-mode.plugin.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
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
alias plint='proselint'

# Spellcheck for .md files.
# https://superuser.com/questions/835860/spell-check-in-the-bash-cli
# https://stackoverflow.com/questions/5567794/can-aspell-output-line-number-and-not-offset-in-pipe-mode
alias sc=spellCheck $1
function spellCheck() {
   for file in "$@"
   do
      let count=`aspell -a < $file | egrep "^\&" | awk '{print $2}' | sort -u | wc -l | awk '{print $1}'`
      # if [ $count -eq 0 ]; then
      #    printf "\n$No spelling errors on $file\n"
      # fi
      if [ $count -gt 0 ]; then
         printf "\nSpelling error(s) in $file\n"
         echo "======================================================"
         < $file aspell list |
            sort |
            uniq |
            while read word; do grep -on "\<$word\>" $file; done |
            sponge |
            sort -n
         # aspell -a < $file  | egrep "^\&" | awk '{print $2}' | sort -u
      fi
   done
}
