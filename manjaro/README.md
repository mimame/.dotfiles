# [Manjaro](https://manjaro.org/)

## Stow
stow --target=/ manjaro

## Installed packages which are not dependencies
`pacman --query --explicit --native --unrequired --quiet`

## AUR installed packages
`pacman --query --explicit --foreign --unrequired --quiet`

## Installed language packages

### Python
`pip list | cut -d' ' -f1`

### Ruby
`gem list --no-versions`

### Go
`cd ~; go list ./...`
