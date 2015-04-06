#!/bin/bash

PLUGINS=( https://github.com/scrooloose/nerdtree.git \
          https://github.com/majutsushi/tagbar.git   \
          https://github.com/fholgado/minibufexpl.vim.git )

installPlugin(){
  echo "Trying to install ${1##*/}"
  mkdir temporalDownload
  git clone $1 temporalDownload/
  rm -rf temporalDownload/.git*
  find temporalDownload -mindepth 1 -maxdepth 2 -type d | xargs -i cp -R {} ~/.vim
  echo "${1##*/} installed"
  rm -rf temporalDownload 
}

usage(){
  echo "Error. Usage: $0 [-r|--rc] [-p|--plugins] [-a|--all]"
  exit 1
}

if [ $# = 0 ]; then
  usage
fi

INSTALL_RC=false
INSTALL_PLUGINS=false

while [ $# -gt 0 ]; do
  case "$1" in
    -a | --all ) INSTALL_PLUGINS=true;INSTALL_RC=true;;
    -r | --rc ) INSTALL_RC=true;;
    -p | --plugins ) INSTALL_PLUGINS=true;;
    * ) usage;;
  esac
  shift
done

if [ $INSTALL_PLUGINS == true ]; then
  if [ ! -d ~/.vim ]; then
    mkdir -p ~/.vim
  fi

  for plugin in ${PLUGINS[@]}; do
    installPlugin $plugin
  done 
fi

# install rc files
if [ $INSTALL_RC == true ]; then
  for file in rcFiles/*; do
    cp -v $file ~/.${file##*/}
  done
fi
