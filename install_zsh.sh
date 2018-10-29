#!/bin/bash

sudo apt-get install zsh git -y

chsh -s $(whoami) $(which zsh)

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

sed 's/plugins\=(git)/plugins\=(git\ docker\ autojump\ zsh-autosuggestions\ zsh-syntax-highlighting)/g' ~/.zshrc -i
