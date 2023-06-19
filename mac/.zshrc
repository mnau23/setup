# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
# ZSH_THEME="robbyrussell"        # default
ZSH_THEME="powerlevel10k/powerlevel10k"

# Auto-update behavior
zstyle ':omz:update' mode auto    # update automatically without asking
zstyle ':omz:update' frequency 7  # check weekly for updates

ENABLE_CORRECTION="true"

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

# Powerlevel10k
## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# krew - package manager for kubectl plugins
export PATH="$HOME/.krew/bin:$PATH"

# nvm - Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pyenv - Python Version Management
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# Poetry
export PATH="$HOME/.poetry/bin:$PATH"

######################################################################
                              # USEFUL #                              
######################################################################

export HOMEBREW_BREWFILE=~/<CUSTOM_PATH>/Brewfile

# Update Homebrew and its packages/casks
## eg: brewup
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
## eg: jdk <version_number>
function setJdkVersion() {
  export JAVA_HOME=$(/usr/libexec/java_home -v"$1");
  java -version
}
alias jdk=setJdkVersion

# JWT decoder
## eg: jwt "<example>"
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
## eg: kubedecode <secret_name> <key_name>
function getDecodedSecret() {
  secret_name=$1
  key_name=$2
  kubectl get secrets $secret_name -o yaml | rg $key_name | grep -v "{" | sed 's/ * //g' | awk -F ":" '{printf($1": "); system("echo " $2 " | base64 -d");
  printf("\n")}'
}
alias kubedecode=getDecodedSecret

# Copy secret between namespaces in the same cluster
## eg: copy-secret <secret_name> <source_ns> <dest_ns>
function copySecretInNamespace() {
  kubectl neat get -- secret "$1" --namespace="$2" -o json | jq 'del(.metadata.namespace)' | kubectl apply --namespace=$3 -f -;
}
alias copy-secret=copySecretInNamespace

# Scale deployment to a specific number of replicas in a namespace
## eg: ks <replicas_nr> <deployment_name>
function scaleDeployment() {
  kubectl scale --replicas=$1 deployment $2
}
alias ks=scaleDeployment

# Delete a specific group of pods (used to cleanup pods with the same status)
## eg: kdl_pods <pod_status>
function deletePodsInNamespace() {
  kubectl get pods | grep $1 | cut -d' ' -f 1 | xargs kubectl delete pod
}
alias kdl_pods=deletePodsInNamespace

# Disable or enable a cronjob
## eg: kp_cronjob <disable|enable> <cronjob_name>
function changeCronjobStatus() {
  if [[ $1 == "disable" || $1 == "d" ]]; then
    kubectl patch cronjob $2 -p '{"spec" : {"suspend" : true }}'
  elif [[ $1 == "enable" || $1 == "e" ]]; then
    kubectl patch cronjob $2 -p '{"spec" : {"suspend" : false }}'
  else
    printf "Missing or wrong argument(s)...\nUsage: kp_cronjob <disable|enable> <cronjob_name>\n"
  fi
}
alias kp_cronjob=changeCronjobStatus

# Backup files in Obsidian Vault
## eg: obsidian-backup
function backupObsidianVaultToGithub() {
  cd ~/<CUSTOM_PATH>/obsidian-vault
  git add .
  now="`date +'%Y-%m-%d %H:%M'`"
  msg="vault backup $now" # vault backup YYYY-MM-DD HH:mm
  git commit -m "$msg"
  git push
  cd ~
}
alias obsidian-backup=backupObsidianVaultToGithub

#####################################################################
                              # ALIAS #                              
#####################################################################

## random
alias out="cd .."
alias remindall="less ~/.oh-my-zsh/plugins/git/git.plugin.zsh"
alias zip="zip -x '*.DS_Store' -vr"
## Django
alias dj="python manage.py"
alias djm="python manage.py migrate"
alias djmkm="python manage.py makemigrations"
alias djrs="python manage.py runserver"
## Docker
alias d="docker"
alias dcon="docker container"
alias dimg="docker image"
## Git
alias gfp="git fetch && git pull"
alias gl="git log"
alias gpl="git pull"
alias gps="git push"
alias pretty="git log --graph --pretty='%Cred%h%Creset %Cgreen(%ad) %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset %s' --date=short --abbrev-commit"
alias prettys="git log --graph --pretty='%Cred%h%Creset %Cgreen(%ad) %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset %s' --date=short --stat"
## Kubernetes
alias k="kubectl"
alias ka="kubectl apply"
alias kdl="kubectl delete"
alias kds="kubectl describe"
alias kg="kubectl get"
alias kl="kubectl logs"
# ---
alias kcron="kubectl get cronjob"
alias kdepl="kubectl get deployments"
alias king="kubectl get ingress"
alias knodes="kubectl get nodes"
alias kpods="kubectl get pods"
alias ksec="kubectl get secrets"
## Leapp
alias llist="leapp session list"
alias lstart="leapp session start"
alias lstop="leapp session stop"
## Terraform
alias tf="terraform"
