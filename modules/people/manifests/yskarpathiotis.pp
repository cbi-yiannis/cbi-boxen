class people::yskarpathiotis { # Change to your GitHub username
  # if we wanted to add some module for only this user
  # include tmux
  # include dropbox
  # include onepassword
  # include virtualbox
  # include vagrant
  # include chrome
  include homebrew
     
    $path = "/Users/${::boxen_user}"

  notify { "install rbenv-gemset": }
  package { 'rbenv-gemset':
    ensure => present,
    install_options => [
      '--with-fpm'
      ]
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
    notify { "install reattach-to-user-namespace": }
    package { 'reattach-to-user-namespace':
      ensure => present
    }

    notify { "install oh-my-zsh": }
    exec { "curl -L http://install.ohmyz.sh | sh":
      cwd     => $path,
      creates => "${path}/.oh-my-zsh",
      path    => ["/usr/bin", "/usr/sbin"]
    }
 
    notify { "install pathogen": }
    exec { "mkdir -p ${path}/.vim/autoload ${path}/.vim/bundle && curl -LSso ${path}/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim":
      cwd     => $path,
      creates => "${path}/.vim/autoload/pathogen.vim",
      path    => ["/usr/bin", "/usr/sbin"]
    }
 
    notify { "install Vundle": }
    exec { "git clone https://github.com/VundleVim/Vundle.vim.git ${path}/.vim/bundle/Vundle.vim":
      cwd     => $path,
      creates => "${path}/.vim/bundle/Vundle.vim",
      path    => ["/usr/bin", "/usr/sbin"]
    }
 
    notify { "move .zshrc": }
    exec { "mv .zshrc .zshrc_original":
      cwd     => $path,
      creates => "${path}/.vim/bundle/Vundle.vim",
      path    => ["/usr/bin", "/usr/sbin"]
    }

    notify { "setup vim and oh-my-zsh directories": }
    exec { "mkdir -p ${path}/.oh-my-zsh/custom/themes && mkdir -p ${path}/.vim/_backup && mkdir -p ${path}/.vim/_temp":
      cwd     => $path,
      creates => "${path}/.oh-my-zsh/custom/themes",
      path    => ["/usr/bin", "/usr/sbin"]
    }

    notify { "download dotfiles": }
    exec { "git clone https://github.com/yskarpathiotis/dotfiles.git ${path}/.dotfiles":
      cwd     => $path,
      creates => "${path}/.vim/bundle/Vundle.vim",
      path    => ["/usr/bin", "/usr/sbin"]
    }

    exec { "ln -s ${path}/.dotfiles/.vimrc ${path}/.vimrc && ln -s ${path}/dotfiles/.tmux.conf ${path}/.tmux.conf && ln -s ${path}/dotfiles/.zshrc ${path}/.zshrc":
      cwd     => $path,
      creates => "${path}/.vimrc",
      path    => ["/usr/bin", "/usr/sbin"]
    }

    notify { "setup Code dir": }
    exec { "mkdir -p ${path}/Code/Sites/Rails/cbi":
      cwd     => $path,
      creates => "${path}/Code/Sites/Rails/cbi",
      path    => ["/usr/bin", "/usr/sbin"]
    }
    
    notify { "download and link oh-my-zsh solaryan": }
    exec { "git clone https://github.com/yskarpathiotis/oh-my-zsh-solaryan-theme.git":
      cwd     => "${path}/Code",
      creates => "${path}/Code/oh-my-zsh-solaryan",
      path    => ["/usr/bin", "/usr/sbin"]
    }

    exec { "ln -s ${path}/Code/oh-my-zsh-solaryan-theme/solaryan.zsh-theme ${path}/.oh-my-zsh/custom/themes/solaryan.zsh-theme":
      cwd     => "${path}/Code",
      creates => "${path}/.oh-my-zsh/custom/themes/solaryan.zsh-theme",
      path    => ["/usr/bin", "/usr/sbin"]
    }

    notify { "download and link rdir": }
    exec { "git clone https://github.com/yskarpathiotis/rdir.git":
      cwd     => "${path}/Code",
      creates => "${path}/Code/rdir",
      path    => ["/usr/bin", "/usr/sbin"]
    }

    exec { "ln -s ${path}/Code/rdir ${path}/.oh-my-zsh/custom/plugins/rdir":
      cwd     => "${path}/Code",
      creates => "${path}/.oh-my-zsh/custom/plugins/rdir",
      path    => ["/usr/bin", "/usr/sbin"]
    }


}
