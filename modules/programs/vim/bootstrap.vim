if empty(glob('~/.local/share/nvim/site/pack/packer/start/packer.nvim'))
    silent !sh -c '
                \ git clone --depth 1 https://github.com/wbthomason/packer.nvim\
                \ ~/.local/share/nvim/site/pack/packer/start/packer.nvim'
endif

set termguicolors
