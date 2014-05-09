group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File { owner => 0, group => 0, mode => 0644 }

class {'apt':
  always_apt_update => true,
}

Class['::apt::update'] -> Package <|
    title != 'python-software-properties'
and title != 'software-properties-common'
|>


class { 'puphpet::dotfiles': }

package { [
    'build-essential',
    'vim',
    'curl',
    'git-core',
    'sphinxsearch',
    'zsh',
    'imagemagick',
    'mongodb',
    'sqlite3',
    'libsqlite3-dev'
  ]:
  ensure  => 'installed',
}

# Install Node.js

include nodejs

# Install Ruby/Rubygems

class { 'ruby':
    gems_version  => 'latest'
}

# Install Gems

package { 'sass':
  ensure   => '3.3.4',
  provider => 'gem',
  require => Class['ruby']
}

# Install global NPM packages

package { 'requirejs':
  ensure   => present,
  provider => 'npm',
  require => Class['nodejs']
}

package { 'bower':
  ensure   => present,
  provider => 'npm',
  require => Class['nodejs']
}

class { 'apache': }

apache::dotconf { 'custom':
  content => 'EnableSendfile Off',
}

apache::module { 'rewrite': }
apache::module { 'headers': }
apache::module { 'proxy': }

class { 'php':
  service             => 'apache',
  service_autorestart => true,
  module_prefix       => '',
}

php::module { 'php5-mysql': }
php::module { 'php5-cli': }
php::module { 'php5-curl': }
php::module { 'php5-gd': }
php::module { 'php5-imagick': }
php::module { 'php5-intl': }
php::module { 'php5-mcrypt': }
php::module { 'php5-memcache': }
php::module { 'php5-memcached': }
php::module { 'php5-suhosin': }
php::module { 'php-apc': }

class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}

php::pecl::module { 'mongo':
  use_package => false,
  version => '1.2.12',
}

php::pecl::module { 'xdebug':
  use_package => false,
  version     => '2.2.5'
}

$xhprofPath = '/var/www/xhprof'

php::pecl::module { 'xhprof':
  use_package     => false,
  preferred_state => 'beta',
}

if !defined(Package['git-core']) {
  package { 'git-core' : }
}

vcsrepo { $xhprofPath:
  ensure   => present,
  provider => git,
  source   => 'https://github.com/facebook/xhprof.git',
  require  => Package['git-core']
}

file { "${xhprofPath}/xhprof_html":
  ensure  => 'directory',
  owner   => 'vagrant',
  group   => 'vagrant',
  mode    => '0775',
  require => Vcsrepo[$xhprofPath]
}

composer::run { 'xhprof-composer-run':
  path    => $xhprofPath,
  require => [
    Class['composer'],
    File["${xhprofPath}/xhprof_html"]
  ]
}

apache::vhost { 'xhprof':
  server_name => 'xhprof',
  docroot     => "${xhprofPath}/xhprof_html",
  port        => 80,
  priority    => '1',
  require     => [
    Php::Pecl::Module['xhprof'],
    File["${xhprofPath}/xhprof_html"]
  ]
}

class { 'composer':
  require => Package['php5', 'curl'],
}

puphpet::ini { 'php':
  value   => [
    'date.timezone = "Europe/London"'
  ],
  ini     => '/etc/php5/conf.d/zzz_php.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

puphpet::ini { 'custom':
  value   => [
    'engine = on',
    'short_open_tag = on',
    'asp_tags = off',
    'precision = 14',
    'output_buffering = 4096',
    'zlib.output_compression = off',
    'implicit_flush = off',
    'serialize_precision = 100',
    'max_execution_time = 30',
    'log_errors = on',
    'post_max_size = "8M"',
    'upload_max_filesize = "2M"',
    'suhosin.executor.include.whitelist = phar',
    'extension="mongo.so"'
  ],
  ini     => '/etc/php5/conf.d/zzz_custom.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

exec { "enable_xdebug":
  command => "echo \"zend_extension=`find /usr/lib/php5 -name 'xdebug.so'`\" > /etc/php5/conf.d/xdebug.ini"
}

class { 'mysql::server':
  config_hash   => { 'root_password' => 'root' }
}

class { 'phptools': }
class { 'share': }
class { 'memcached':
    max_memory => '10%'
}
