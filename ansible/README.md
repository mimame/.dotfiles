Deploy all roles
`ansible-playbook playbook.yml --ask-become-pass`
Deploy only specific roles
`ansible-playbook playbook.yml --tags pacman_packages,aur_packages,dotfiles --ask-become-pass`
