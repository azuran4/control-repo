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
  $wikisitename = 'puppet-agent'
  $wikimetanamespace = 'Wiki'
  $wikiserver = "http://10.166.0.6"
  $wikidbserver = 'localhost'
  $wikidbname = 'wiki'
  $wikidbuser = 'root'
  $wikidbpassword = 'training'
  $wikiupgradekey = 'puppet'

  
  class { 'linux': }
  class { 'mediawiki': }
  
}

node 'wiki' {

  class { 'linux': }
  class { 'mediawiki': }

}

node 'wikitest' {

  class { 'linux': }
  class { 'mediawiki': }

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

#  file { '/info.txt':
#    ensure  => 'present',
#    content => inline_template("Created by Puppet at <%= Time.now %>\n"),






#  }

#  package { 'ntp':
#    ensure => 'installed',
#  }

  service { $ntpservice:
    ensure => 'running',
    enable => true,
  }

}

class mediawiki {
  $phpmysql = $osfamily ? {
    'redhat' => 'php-mysql',
    'debian' => 'php-mysql',
    default => 'php-mysql',
    }
   
   package { $phpmysql:
    ensure => 'present';
   }
   
   if $osfamily == 'redhat' {
    package { 'php-xml':
      ensure => 'present',
    }
   }
   
   class { '::apache':
    docroot => '/var/www/html',
    mpm_module => 'prefork',
    subscribe => Package[$phpmysql],
   }
    
   class { '::apache::mod::php':}
   
   vcsrepo { '/var/www/html':
      ensure => present,
      provider => git,
      source => 'https://github.com/wikimedia/mediawiki.git',
      revision => 'REL1_23',
   }
   file { '/var/www/html/index.html':
      ensure => 'absent',
   }
  
   File['/var/www/html/index.html'] -> Vcsrepo['/var/www/html']
   
   class { '::mysql::server':
      root_password => 'training',
   }
   
   class { '::firewall': }
   
   firewall {'000 allow https access':
       port => '80',
       proto => 'tcp',
       action => 'accept',  
   }
   file { 'LocalSettings.php':
       path    => '/var/www/html/LocalSettings.php',
       ensure  => 'file',
       content => template('mediawiki/LocalSettings.erb'),
   }

}
