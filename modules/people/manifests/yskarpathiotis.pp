class people::yskarpathiotis { # Change to your GitHub username
  # if we wanted to add some module for only this user
  include homebrew
     
  $path = "/Users/${::boxen_user}"

  #### HOMEBREW INSTALLS ####
  notify { "install rbenv-gemset": }
  package { 'rbenv-gemset':
    ensure => present,
    install_options => [
      '--with-fpm'
    ]
  }

  notify { "install reattach-to-user-namespace": }
  package { 'reattach-to-user-namespace':
    ensure => present,
    require => Package['install rbenv-gemset']
  }

  notify { "install qt55": }
  package { 'qt55':
    ensure => present,
    require => Package['install rbenv-gemset']
  }

  #### SETUP CODE DIR ####
  notify { "setup Code dir": }
  file { "${path}/Code":
    ensure => 'directory'
  }
  
  #### PATHOGEN ####
  notify { "install pathogen": }
  file { "${path}/.vim/autoload":
    ensure => 'directory'
  }
  file { "${path}/.vim/bundle":
    ensure => 'directory'
  }
  exec { "install pathogen":
    command => "curl -LSso ${path}/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim",
    creates => "${path}/.vim/autoload/pathogen.vim",
    path    => ["/usr/bin", "/usr/sbin"],
    require =>[
      File["${path}/.vim/autoload"],
      File["${path}/.vim/bundle"]
    ]
  }

  #### VUNDLE ####
  notify { "install Vundle": }
  exec { "git clone https://github.com/VundleVim/Vundle.vim.git ${path}/.vim/bundle/Vundle.vim":
    cwd     => $path,
    creates => "${path}/.vim/bundle/Vundle.vim",
    path    => ["/usr/bin", "/usr/sbin"]
  }

  #### SETUP ZSH ####
  notify { "install oh-my-zsh": }
  exec { "install oh-my-zsh":
    command => "curl -L http://install.ohmyz.sh | sh",
    cwd     => $path,
    creates => "${path}/.oh-my-zsh",
    path    => ["/usr/bin", "/usr/sbin"]
  }

  notify { "move .zshrc": }
  exec { "mv .zshrc .zshrc_original":
    cwd     => $path,
    creates => "${path}/.vim/bundle/Vundle.vim",
    path    => ["/usr/bin", "/usr/sbin"],
    require => Exec['install oh-my-zsh']
  }

  #### SETUP DIR ####
  notify { "setup vim and oh-my-zsh directories": }
  file { "${path}/.vim/_temp":
    ensure => 'directory'
  }
  file { "${path}/.vim/_backup":
    ensure => 'directory'
  }
  file { "${path}/.oh-my-zsh/custom/themes":
    ensure => 'directory'
  }

  #### .dotfiles ####
  notify { "download dotfiles": }
  exec { "git clone https://github.com/yskarpathiotis/dotfiles.git ${path}/.dotfiles":
    cwd     => $path,
    creates => "${path}/.vim/bundle/Vundle.vim",
    path    => ["/usr/bin", "/usr/sbin"],
    before  => [
      File["${path}/.dotfiles/.vimrc"],
      File["${path}/.dotfiles/.tmux.conf"],
      File["${path}/.dotfiles/.zshrc"]
    ]
  }

  file { "${path}/.vimrc":
    ensure => link,
    target => "${path}/.dotfiles/.vimrc"
  }

  file { "${path}/.tmux.conf":
    ensure => link,
    target => "${path}/.dotfiles/.tmux.conf"
  }

  file { "${path}/.zshrc":
    ensure => link,
    target => "${path}/.dotfiles/.zshrc"
  }

  #### SOLARYAN ####
  notify { "download and link oh-my-zsh solaryan": }
  exec { "clone solar-yan":
    command => "git clone https://github.com/yskarpathiotis/oh-my-zsh-solaryan-theme.git",
    cwd     => "${path}/Code",
    creates => "${path}/Code/oh-my-zsh-solaryan",
    path    => ["/usr/bin", "/usr/sbin"],
    require => File["${path}/Code"]
  }

  file { "${path}/.oh-my-zsh/custom/themes/solaryan.zsh-theme":
    ensure  => link,
    target  => "${path}/Code/oh-my-zsh-solaryan-theme/solaryan.zsh-theme",
    require =>  Exec['clone solar-yan']
  }

  #### RDIR ####
  notify { "download and link rdir": }
  exec { "clone rdir":
    command => "git clone https://github.com/yskarpathiotis/rdir.git",
    cwd     => "${path}/Code",
    creates => "${path}/Code/rdir",
    path    => ["/usr/bin", "/usr/sbin"],
    require => File["${path}/Code"]
  }

  file { "${path}/.oh-my-zsh/custom/plugins/rdir":
    ensure => link,
    target => "${path}/Code/rdir",
    require =>  Exec['clone rdir']
  }

}
