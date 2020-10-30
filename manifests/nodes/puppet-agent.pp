node 'puppet-agent' {
  package { 'mc':
    ensure => 'absent',
  }
  package { 'ntp':
    ensure => 'installed',
  }
  package { 'sngrep':
    ensure => 'installed',
    
  class { 'linux': }
  class { 'mediawiki': }
  }
}


class linux {

  $admintools = ['git', 'nano', 'screen']

  package { $admintools:
    ensure => 'installed',
  }

  $ntpservice = $osfamily ? {
    'redhat' => 'ntpd',
    'debian' => 'ntp',
    default  => 'ntp',
  }

  file { '/info.txt':
    ensure  => 'present',
    content => inline_template("Created by Puppet at <%= Time.now %>\n"),
  }

  package { 'ntp':
    ensure => 'installed',
  }

  service { $ntpservice:
    ensure => 'running',
    enable => true,
  }

}

