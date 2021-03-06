class mediawiki {
  $phpmysql = $osfamily ? {
    'redhat' => 'php-mysql',
    'debian' => 'php5-mysql',
    default => 'php5-mysql',
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
    docroot => '/var/www/html'
    mpm_module => 'prefork',
    subscribe => Package[$phpmysql],
   }
    
   class { '::apache::mod::php':}
   
   vcsrepo {' /var/www/html':
      ensure => present,
      provider => git,
      source => 'https://github.com/wikimedia/mediawiki.git',
      revision => 'REL1_23',
   }
   
#   file { '/var/www/html/index.html':
#    ensure => 'absent',
#   }
   file { 'LocalSettings.php':
       path    => '/var/www/html/LocalSettings.php',
       ensure  => 'file',
       content => template('mediawiki/LocalSettings.erb'),
   }
 }
