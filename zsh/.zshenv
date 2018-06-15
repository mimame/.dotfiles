# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zprofile
# respect the color
export LESS='-F -g -i -M -R -S -w -X -z-4'
export PAGER='less'
# Alias
alias sshfs="sshfs -o allow_other,default_permissions,follow_symlinks,kernel_cache,reconnect,ServerAliveInterval=60,ServerAliveCountMax=3"


if [ -x "$(command -v "firefox-developer-edition")" ]; then
  alias firefox='firefox-developer-edition'
  export BROWSER='firefox-developer-edition'
else
  export BROWSER='firefox'
fi

# Vim as default editor
export EDITOR=vim
export VISUAL=vim
export TMPDIR='/tmp'
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"
# Always use user Ruby gems by default
export PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export GEM_HOME="$HOME/.gem"

# Tar wrapper
function t {
tar cpf "$1.tar" "$1"
}

# Copy using tar
function ct {
  tar cpf - $1 | (cd $2 && tar xp )
}

# aux function: try to use parallel version if available of the compressor
function _use_compressor_parallel_if_avaible {

  compressor="$1"
  parallel_compressor="$1"

  case $compressor in
    gzip)
      parallel_compressor="pigz"
      ;;
    xz)
      parallel_compressor="pixz"
      ;;
    *)
      #echo "unknown parallel compressor for the '$1' compressor" 1>&2
      ;;
  esac

  if [ -x "$(command -v "$parallel_compressor")" ]; then
    echo "$parallel_compressor"
  else
    #echo "\\e[1m\\e[31mwarning: '${1}' is desired (using '${2}' by default)\\e[0m" 1>&2
    echo "$compressor"
  fi
}

# aux function: generate suffix for the compressors
function _compressor_suffix {
  suffix=""
  case $1 in
    gzip|pigz)
      suffix="gz"
      ;;
    xz|pixz)
      suffix="xz"
      ;;
    *)
      echo "unknown suffix for the '$1' compressor" 1>&2
      return 1
      ;;
  esac

  echo "$suffix"
}

# function _compress_tar parallel_compressor std_compressor suffix level file/folder
function _compress_tar {

  if [ ${#[@]} -lt 3 ]; then
    echo "_compress_tar parallel_compressor std_compressor suffix level file/folder" 1>&2
    return 1
  fi

  compressor="$(_use_compressor_parallel_if_avaible $1)"

  suffix="$(_compressor_suffix $compressor)"

  tar cpf - "$3" | $compressor "-${2}"> "${3}.tar.${suffix}"
}

# User Firefox Developer Edition by default
if [ -x "$(command -v "firefox-developer-edition")" ]; then
  alias firefox='firefox-developer-edition'
  export BROWSER='firefox-developer-edition'
else
  export BROWSER='firefox'
fi

# Compression alias
alias tgz="_compress_tar gzip 6"
alias tgz9="_compress_tar gzip 9"
alias txz="_compress_tar xz 6"
alias txz1="_compress_tar xz 1"
alias txz9="_compress_tar xz 9"

# Tab mount output
function mount {
  if [ -z "$1" ]; then
    /usr/bin/mount | column -t
  else
    /usr/bin/mount "$@"
  fi
}

# Send tar by ssh
function ssh-send-tar {

  if [ ${#[@]} -lt 3 ]; then
    echo "ssh-send-tar SSH_PARAMS user@host ORIGIN_PATH REMOTE_TARGET_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path="${@[-2]}"
  folder_name=$(basename $origin_path)
  remote_target_folder="${@[-1]}"

  # remove origin and destination from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove remote_target_folder
  unset "ssh_params[${#ssh_params[@]}-1]" # remove origin_path

  tar cpf - $origin_path | ssh $ssh_params "(cd $remote_target_folder && cat > ${folder_name}.tar)"
}

# Send folder using ssh (and tar)
function ssh-send-folder {

  if [ ${#[@]} -lt 3 ]; then
    echo "ssh-send-folder SSH_PARAMS user@host ORIGIN_PATH REMOTE_TARGET_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path="${@[-2]}"
  folder_name=$(basename $origin_path)
  remote_target_folder="${@[-1]}"

  # remove origin and destination from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove remote_target_folder
  unset "ssh_params[${#ssh_params[@]}-1]" # remove origin_path

  tar cpf - $origin_path | ssh $ssh_params "(cd $remote_target_folder && tar xp)"
}

# Get tar by ssh
function ssh-get-tar {

  if [ ${#[@]} -lt 2 ]; then
    echo "ssh-get-folder SSH_PARAMS user@host ORIGIN_PATH_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path_folder="${@[-1]}" # last paramenter is the path
  dir_name=$(dirname $origin_path_folder)
  folder_name=$(basename $origin_path_folder)

  # remove origin from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove origin_path_folder

  ssh $ssh_params "(cd $dir_name && tar cpf - $folder_name)" > "${folder_name}.tar"
}

function ssh-get-folder {

  if [ ${#[@]} -lt 2 ]; then
    echo "ssh-get-folder SSH_PARAMS user@host ORIGIN_PATH_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path_folder="${@[-1]}" # last paramenter is the path
  dir_name=$(dirname $origin_path_folder)
  folder_name=$(basename $origin_path_folder)

  # remove origin from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove origin_path_folder

  ssh $ssh_params "(cd $dir_name && tar cpf - $folder_name)" | tar xp
}

# Send tgz by ssh
function ssh-send-tgz {

  if [ ${#[@]} -lt 3 ]; then
    echo "ssh-send-tgz SSH_PARAMS user@host ORIGIN_PATH REMOTE_TARGET_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path="${@[-2]}"
  folder_name=$(basename $origin_path)
  remote_target_folder="${@[-1]}"

  # remove origin and destination from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove remote_target_folder
  unset "ssh_params[${#ssh_params[@]}-1]" # remove origin_path

  compressor="$(_use_compressor_parallel_if_avaible gzip)"

  tar cpf - $origin_path | $compressor -c - | ssh $ssh_params "(cd $remote_target_folder && cat > ${folder_name}.tar.gz)"
}

# Send folder by ssh (using gz)
function ssh-send-folder-gz {

  if [ ${#[@]} -lt 3 ]; then
    echo "ssh-send-folder-gz SSH_PARAMS user@host ORIGIN_PATH REMOTE_TARGET_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path="${@[-2]}"
  folder_name=$(basename $origin_path)
  remote_target_folder="${@[-1]}"

  # remove origin and destination from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove remote_target_folder
  unset "ssh_params[${#ssh_params[@]}-1]" # remove origin_path

  compressor="$(_use_compressor_parallel_if_avaible gzip)"

  tar cpf - $origin_path | $compressor -c - | ssh $ssh_params "(cd $remote_target_folder && gzip -cd | tar xp)"
}

# Get tgz by ssh
function ssh-get-tgz {

  if [ ${#[@]} -lt 2 ]; then
    echo "ssh-get-tgz SSH_PARAMS user@host ORIGIN_PATH_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path_folder="${@[-1]}" # last paramenter is the path
  dir_name=$(dirname $origin_path_folder)
  folder_name=$(basename $origin_path_folder)

  # remove origin from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove origin_path_folder

  compressor="$(_use_compressor_parallel_if_avaible gzip)"

  ssh $ssh_params "(cd $dir_name && tar cpf - $folder_name | gzip -c)" > "${folder_name}.tar.gz"

}

# Get folder by ssh (using gz)
function ssh-get-folder-gz {

  if [ ${#[@]} -lt 2 ]; then
    echo "ssh-get-folder-gz SSH_PARAMS user@host ORIGIN_PATH_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path_folder="${@[-1]}" # last paramenter is the path
  dir_name=$(dirname $origin_path_folder)
  folder_name=$(basename $origin_path_folder)

  # remove origin from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove origin_path_folder

  compressor="$(_use_compressor_parallel_if_avaible gzip)"

  ssh $ssh_params "(cd $dir_name && tar cpf - $folder_name | gzip -c)" | $compressor -cd | tar xp
}

# Send txz by ssh
function ssh-send-txz {

  if [ ${#[@]} -lt 3 ]; then
    echo "ssh-send-txz SSH_PARAMS user@host ORIGIN_PATH REMOTE_TARGET_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path="${@[-2]}"
  folder_name=$(basename $origin_path)
  remote_target_folder="${@[-1]}"

  # remove origin and destination from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove remote_target_folder
  unset "ssh_params[${#ssh_params[@]}-1]" # remove origin_path

  # pixz doesn't work with -c option
  # xz -T0 -d only works for xz -T0 compression
  tar cpf - $origin_path | xz -T0 -c - | ssh $ssh_params "(cd $remote_target_folder && cat > ${folder_name}.tar.xz)"
}

# Send folder by ssh (using xz)
function ssh-send-folder-xz {

  if [ ${#[@]} -lt 3 ]; then
    echo "ssh-send-folder-xz SSH_PARAMS user@host ORIGIN_PATH REMOTE_TARGET_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path="${@[-2]}"
  folder_name=$(basename $origin_path)
  remote_target_folder="${@[-1]}"

  # remove origin and destination from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove remote_target_folder
  unset "ssh_params[${#ssh_params[@]}-1]" # remove origin_path

  # pixz doesn't work with -c option
  # xz -T0 -d only works for xz -T0 compression
  tar cpf - $origin_path | xz -T0 -c - | ssh $ssh_params "(cd $remote_target_folder && xz -T0 -cd | tar xp)"
}

# Send txz by ssh
function ssh-get-txz {

  if [ ${#[@]} -lt 2 ]; then
    echo "ssh-get-txz SSH_PARAMS user@host ORIGIN_PATH_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path_folder="${@[-1]}" # last paramenter is the path
  dir_name=$(dirname $origin_path_folder)
  folder_name=$(basename $origin_path_folder)

  # remove origin from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove origin_path_folder

  ssh $ssh_params "(cd $dir_name && tar cpf - $folder_name | xz -T0 -c)" > "${folder_name}.tar.xz"
}

# Get folder by ssh (using xz)
function ssh-get-folder-xz {

  if [ ${#[@]} -lt 2 ]; then
    echo "ssh-get-folder-xz SSH_PARAMS user@host ORIGIN_PATH_FOLDER" 1>&2
  fi

  ssh_params=( "$@" )
  origin_path_folder="${@[-1]}" # last paramenter is the path
  dir_name=$(dirname $origin_path_folder)
  folder_name=$(basename $origin_path_folder)

  # remove origin from param array
  unset "ssh_params[${#ssh_params[@]}]" # remove origin_path_folder

  ssh $ssh_params "(cd $dir_name && tar cpf - $folder_name | xz -T0 -c)" | xz -T0 -cd | tar xp
}

function mkcd {
  mkdir -p $1 && cd $1
}

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
