# [Manjaro](https://manjaro.org/)

## Installed packages which are not dependencies neither optional dependencies
`pacman --query --explicit --native --unrequired --unrequired --quiet >! pacman.txt`

## AUR installed packages which are not dependencies neither optional dependencies
`pacman --query --explicit --foreign --unrequired --unrequired --quiet >! aur.txt`

## Installed language packages

### Python
`pip freeze | cut -d'=' -f1 >! python.txt`

### Javascript
`yarn global list | grep -v 'info' | grep -F -- '-' | sed 's/[- ]\+//' >! javascript.txt`

### Julia
`julia -e 'using Pkg;using DelimitedFiles;writedlm("julia.txt",collect(keys(Pkg.installed())))'`

### Ruby
`gem list --no-versions >! ruby.txt`

### Go
`cd ~; go list ./... >! go.txt`
