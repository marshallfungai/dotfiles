" ~/.config/nvim/init.vim
if filereadable(stdpath('config') .. '/init.lua')
  luafile $HOME/.config/nvim/init.lua
endif
