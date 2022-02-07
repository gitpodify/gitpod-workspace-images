#!/usr/bin/env zsh
# shellcheck shell=bash

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# TODO: Only use these when inside an Gitpod workspace and the gp binary exists.
export EDITOR="command gp open -w" VISUAL="command gp open -w"

# Path to your oh-my-zsh installation, to be referenced later.
export ZSH="$HOME/.oh-my-zsh"

# Homebrew should be loaded first before omz
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Do magic on recurisive sourcing on other our zshrc.d.
# First, source our zsh ports first.
if [ -d "$HOME/.zshrc.d" ]; then
  for i in $(ls -A $HOME/.zshrc.d/); do
    source $HOME/.zshrc.d/$i;
  done
fi
# The source out user customizations there.
if [ -d "$HOME/.gitpodify/custom-zshrc.d" ]; then
  for i in $(ls -A $HOME/.gitpodify/custom-zshrc.d/); do
    source $HOME/.gitpodify/custom-zshrc.d/$i;
  done
fi

# Check if SOURCED_VIA_CUSTOM_ZSHRC isn't empty and skip the default config.
if [[ $SOURCED_VIA_CUSTOM_ZSHRC != "" ]]; then
    true
else
    # Set name of the theme to load --- if set to "random", it will
    # load a random theme each time oh-my-zsh is loaded, in which case,
    # to know which specific one was loaded, run: echo $RANDOM_THEME
    # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    ZSH_THEME="robbyrussell"

    # Set list of themes to pick from when loading at random
    # Setting this variable when ZSH_THEME=random will cause zsh to load
    # a theme from this variable instead of looking in $ZSH/themes/
    # If set to an empty array, this variable will have no effect.
    # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

    # Uncomment the following line to use case-sensitive completion.
    CASE_SENSITIVE="false"

    # Uncomment the following line to use hyphen-insensitive completion.
    # Case-sensitive completion must be off. _ and - will be interchangeable.
    HYPHEN_INSENSITIVE="true"

    # Uncomment one of the following lines to change the auto-update behavior
    zstyle ':omz:update' mode disabled  # disable automatic updates
    # zstyle ':omz:update' mode auto      # update automatically without asking
    # zstyle ':omz:update' mode reminder  # just remind me to update when it's time

    # Uncomment the following line to enable command auto-correction.
    ENABLE_CORRECTION="true"

    # Uncomment the following line to display red dots whilst waiting for completion.
    # You can also set it to another string to have that shown instead of the default red dots.
    # e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
    # Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
    COMPLETION_WAITING_DOTS="true"

    # Uncomment the following line if you want to disable marking untracked files
    # under VCS as dirty. This makes repository status check for large repositories
    # much, much faster.
    DISABLE_UNTRACKED_FILES_DIRTY="true"

    # Uncomment the following line if you want to change the command execution time
    # stamp shown in the history command output.
    # You can set one of the optional three formats:
    # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
    # or set a custom format using the strftime function format specifications,
    # see 'man strftime' for details.
    HIST_STAMPS="mm/dd/yyyy"

    # Which plugins would you like to load?
    # Standard plugins can be found in $ZSH/plugins/
    # Custom plugins may be added to $ZSH_CUSTOM/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.
    plugins=(
        git
        command-not-found
        git-flow
        git-prompt
        nvm
        yarn
        thefuck
        git-auto-fetch
        git-escape-magic
        git-extras
        gitfast
        github
        gitignore
        git-lfs
        pyenv
        brew
    )

    source $ZSH/oh-my-zsh.sh
fi

# direnv
[[ "$(command -v direnv)" != "" ]] && eval "$(direnv hook zsh)"

# did you misspell it?
if [[ "$(command -v thefuck)" != "" ]]; then
  eval "$(thefuck --alias ohfuck)"
  eval "$(thefuck --alias holy-shit)"
fi
