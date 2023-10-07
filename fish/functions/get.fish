function get
    # https://github.com/zimfw/zimfw/blob/master/modules/utility/init.zsh
    if [ -x "$(command -v aria2c)" ]
        aria2c --max-connection-per-server=2 --continue "$argv"
    else if test -x "$(command -v axel)"
        axel --num-connections=2 --alternate "$argv"
    else if test -x "$(command -v wget)"
        wget --continue --progress=bar --timestamping "$argv"
    else if test -x "$(command -v curl)"
        curl --continue-at - --location --progress-bar --remote-name --remote-time "$argv"
    end
end
