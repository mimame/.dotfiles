function yazi --description "Launch Yazi with self-synced plugins (see bootstrap_yazi_packages)"
    bootstrap_yazi_packages
    command yazi $argv
end
