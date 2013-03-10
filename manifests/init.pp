# Sets up Spideroak
class spideroak (
  $username = null,
  $password = null,
  $device_name = $::hostname,
  $reinstall = false
) {

  ### TODO - if ubuntu
  apt::key { 'spideroak':
    key_source => 'http://apt.spideroak.com/spideroak-apt-pubkey.asc'
  }

  apt::source { 'spideroak':
    location    => 'http://apt.spideroak.com/ubuntu-spideroak-hardy/',
    release     => 'release',
    repos       => 'restricted',
    include_src => false,
    require     => Apt::Key['spideroak']
  }
  ### TODO - end if ubuntu

  package { 'spideroak':
    ensure    => installed,
    require   => Apt::Source['spideroak'],
  }

  file { '/root/spideroak_setup.json':
    ensure  => present,
    content => template('spideroak/spideroak_setup.json.erb'),
    mode    => '0500',
    owner   => 'root',
    group   => 'root'
  }

  exec { 'spideroak-root':
    command => '/usr/bin/SpiderOak --setup=/root/spideroak_setup.json',
    require => [
      File['/root/spideroak_setup.json'],
      Package['spideroak']
    ],
    creates => '/root/.SpiderOak',
    user    => 'root'
  }

  file { '/etc/init/spideroak.conf':
    source   => "puppet:///modules/spideroak/spideroak-init.conf",
    require  => Exec['spideroak-root']
  }

  file { '/etc/init.d/spideroak':
    ensure   => link,
    target   => '/lib/init/upstart-job',
    require  => [
      Package['spideroak'],
      Exec['spideroak-root'],
      File['/etc/init/spideroak.conf']
    ]
  }

  service { 'spideroak':
    ensure   => running,
    provider => 'upstart',
    require  => [
      File['/etc/init.d/spideroak'],
      Exec['spideroak-root']
    ]
  }

}
