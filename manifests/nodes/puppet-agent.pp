node 'puppet-agent' {
  package { 'mc':
    ensure => 'absent',
  }
  package { 'ntp':
    ensure => 'installed',
  }
  package { 'sngrep':
    ensure => 'installed',
  }
}
