#!/usr/bin/env zsh
# shellcheck shell=bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"