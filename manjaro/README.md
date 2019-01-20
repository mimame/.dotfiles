# [Manjaro](https://manjaro.org/)

## Stow
stow --target=/ manjaro

## Installed packages which are not dependencies neither optional dependencies
`pacman --query --explicit --native --unrequired --unrequired --quiet`

## AUR installed packages which are not dependencies neither optional dependencies
`pacman --query --explicit --foreign --unrequired --unrequired --quiet`

## Installed language packages

### Python
`pip freeze | cut -d'=' -f1`

### Ruby
`gem list --no-versions`

### Go
`cd ~; go list ./...`
