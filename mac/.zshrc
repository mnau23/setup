# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Auto-update behavior
zstyle ':omz:update' mode auto    # update automatically without asking
zstyle ':omz:update' frequency 7  # check weekly for updates

# Plugins
plugins=(
  autoupdate
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

######################################################################
                           # INSTALLATION #                           
######################################################################

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python Version Management
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# Package manager for kubectl plugins
export PATH="$HOME/.krew/bin:$PATH"

######################################################################
                              # USEFUL #                              
######################################################################

export HOMEBREW_BREWFILE=~/<path>/Brewfile

# Update Homebrew and its packages/casks
# EG: brewup
function homebrewUpdater() {
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
alias brewup=homebrewUpdater

# Switch between different Java versions
# EG: jdk <version_number>
function setJdkVersion() {
  export JAVA_HOME=$(/usr/libexec/java_home -v"$1");
  java -version
}
alias jdk=setJdkVersion

# JWT decoder
# EG: jwt "<example>"
function jwtTokenDecoder() {
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
alias jwtdecode=jwtTokenDecoder

# Find and decode a secret based on current context and namespace
# EG: kubedecode <secret_name> <key_name>
function getDecodedSecret() {
  secret_name=$1
  key_name=$2
  kubectl get secrets $secret_name -o yaml | rg $key_name | grep -v "{" | sed 's/ * //g' | awk -F ":" '{printf($1": "); system("echo " $2 " | base64 -d");
  printf("\n")}'
}
alias kubedecode=getDecodedSecret

# Copy secret between namespaces
# EG: copy-secret <secret_name> <source_ns> <dest_ns>
function copySecretInNamespace() {
  kubectl neat get -- secret "$1" --namespace="$2" -o json | jq 'del(.metadata.namespace)' | kubectl apply --namespace=$3 -f -;
}
alias copy-secret=copySecretInNamespace

# Backup files in Obsidian Vault
# EG: obsidian-backup
function backupObsidianVaultToGithub() {
  cd ~/<path>/obsidian-vault
  git add .
  now="`date +'%Y-%m-%d %H:%M'`"
  msg="vault backup $now" # vault backup YYYY-MM-DD HH:mm
  git commit -m "$msg"
  git push
  cd ~
}
alias obsidian-backup=backupObsidianVaultToGithub

# Aliases

### RANDOM
alias remindall="less ~/.oh-my-zsh/plugins/git/git.plugin.zsh"
alias out="cd .."
### GIT
alias gfp="git fetch && git pull"
alias gl="git log"
alias gpl="git pull"
alias gps="git push"
alias pretty="git log --graph --pretty='%Cred%h%Creset %Cgreen(%ad) %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset %s' --date=short --abbrev-commit"
alias prettys="git log --graph --pretty='%Cred%h%Creset %Cgreen(%ad) %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset %s' --date=short --stat"
### KUBERNETES
alias kdelete="kubectl delete"
alias kdepl="kubectl get deployments"
alias king="kubectl get ingress"
alias klogs="kubectl logs"
alias knds="kubectl get nodes"
alias kpods="kubectl get pods"
alias ksec="kubectl get secrets"
