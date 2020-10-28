node 'puppet-agent' {
  package { 'mc':
    ensure => 'installed',
  }
}
