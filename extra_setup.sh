echo "Installing OhMyZSH"
echo `curl -L http://install.ohmyz.sh | sh`
echo "Installing reattach-to-user-namespace"
echo `brew install reattach-to-user-namespace`
echo "Installing Pathogen"
echo `mkdir -p ~/.vim/autoload ~/.vim/bundle && \
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim`
echo "Installing Vundle"
echo `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
echo "setup vim directories"
echo `mkdir -p ~/.oh-my-zsh/custom/themes`
echo `mkdir -p ~/.vim/_backup`
echo `mkdir -p ~/.vim/_temp`
echo "dont forget to install: heroku toolbelt, docker toolbelt, xcode command line tools"
