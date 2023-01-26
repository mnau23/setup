zstyle ':omz:update' mode auto      # update automatically without asking

##############################
  Useful functions and tools
##############################

# Fish-like autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Update Homebrew and its packages/casks
# EG: brewup
brewup() {
  printf "Updating homebrew and local base of packages and versions...\n"
  brew update && echo
  printf "Upgrading outdated packages...\n"
  brew upgrade && echo
  printf "Upgrading casks...\n"
  brew upgrade --cask --greedy && echo
  printf "Cleaning cache...\n"
  brew cleanup --prune=0 -s && echo
  printf "Checking for problems...\n"
  brew doctor
  echo && printf "Upgrading pip...\n"
  python3  -m pip install --upgrade pip && echo
  printf "Done!\n"
}

# Switch between different Java versions
# EG: jdk 11
jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
}


# JWT decoder
# EG: jwt "<example>"
jwt() {
  for part in 1 2; do
    b64="$(cut -f$part -d. <<< "$1" | tr '_-' '/+')"
    len=${#b64}
    n=$((len % 4))
    if [[ 2 -eq n ]]; then
      b64="${b64}=="
    elif [[ 3 -eq n ]]; then
      b64="${b64}="
    fi
    d="$(openssl enc -base64 -d -A <<< "$b64")"
    python -mjson.tool <<< "$d"
    # don't decode further if this is an encrypted JWT (JWE)
    if [[ 1 -eq part ]] && grep '"enc":' <<< "$d" >/dev/null ; then
        exit 0
    fi
  done
}

# Aliases

### RANDOM
alias remindall='less ~/.oh-my-zsh/plugins/git/git.plugin.zsh'
alias out='cd ..'
### GIT
alias gfp='git fetch && git pull'
alias gl='git log'
alias gpl='git pull'
alias gps='git push'
alias pretty="git log --graph --pretty='%Cred%h%Creset %Cgreen(%ad) %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset %s' --date=short --abbrev-commit"
alias prettys="git log --graph --pretty='%Cred%h%Creset %Cgreen(%ad) %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset %s' --date=short --stat"
### KUBERNETES
alias kdelete='kubectl delete'
alias kdepl='kubectl get deployments'
alias klogs='kubectl logs'
alias kpods='kubectl get pods'
alias king='kubectl get ingress'
alias ksec='kubectl get secrets'
