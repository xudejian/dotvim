#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")"

update() {
  IN_DIR=$1
  mkdir -p $IN_DIR
  cd $IN_DIR
  BRANCH=
  if [ ! -z "$3" ]; then
    BRANCH=" -b $3"
  fi
  [ -d .git ] && {
    BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    git fetch --depth 1
      git reset --hard origin/$BRANCH
      git clean -dfx
  } || git clone --depth 1 $BRANCH $2 .
  cd -
}


core=(
  tpope/vim-sensible
  jiangmiao/auto-pairs
  tpope/vim-surround
  fatih/vim-go
  rust-lang/rust.vim
  vim-pandoc/vim-pandoc
  vim-pandoc/vim-pandoc-syntax
  lervag/vimtex
  airblade/vim-rooter
  airblade/vim-gitgutter
  sjl/gundo.vim
  scrooloose/nerdcommenter
  ludovicchabant/vim-gutentags
  skywind3000/gutentags_plus
  junegunn/fzf
  junegunn/fzf.vim
  honza/vim-snippets
  )

for plug in "${core[@]}"
do
  NAME=$(basename $plug)
  case "$plug" in
    git://|https://*)
      ;;
    *)
      plug="https://github.com/$plug";;
  esac
  update pack/_/start/$NAME $plug
done

update pack/coc/opt/coc https://github.com/neoclide/coc.nvim release
update pack/color/start/gruvbox https://github.com/gruvbox-community/gruvbox

./pack/_/start/fzf/install
mkdir -p ~/.cache/vim/undo
mkdir -p ~/.cache/nvim/undo
