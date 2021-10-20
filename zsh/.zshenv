# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zprofile
# respect the color
export LESS='-F -g -i -M -R -S -w -X -z-4'
export PAGER='less'
# Alias

export BROWSER=firefox

# Mandatory to set explicitly the number of threads for Julia
export JULIA_NUM_THREADS=12

export EDITOR=nvim
export VISUAL=nvim
export TMPDIR='/tmp'
# export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export GEM_HOME="$HOME/.gem"
# Always use user Python pip by default
export PIP_USER=y

# Add/Append to PATH
add_path(){
 export PATH="$1:${PATH}"
}

append_path(){
 export PATH="${PATH}:$1"
}

if [ -z "${LOADED_PATHS+1}" ]; then
  export LOADED_PATHS="true"
  # Vim as default editor
  append_path "$HOME/.yarn/bin"
  append_path "$HOME/.bin"
  append_path "$HOME/go/bin"
  append_path "$HOME/.cargo/bin"
  append_path "$HOME/.nimble/bin"
  # Always use user Ruby gems by default
  append_path "$(ruby -e 'print Gem.user_dir')/bin"
  append_path "$HOME/.local/bin"
fi

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
