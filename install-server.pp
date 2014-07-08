# -----------
# Common Part

# ------------
# eDeploy Part

class {'edeploy' :
      rsync_exports     => {'install' => {'path' => '/var/lib/debootstrap/install', 'comment' => 'The Install Path'},
                            'metadata' => {'path' => '/var/lib/debootstrap/metadata', 'comment' => 'The Metadata Path'},},
      onfailure         => 'console',
      rserv_port        => 873,
      http_port         => 80,
      http_path         => '/',
      upload_log        => 1,
      onsuccess         => 'kexec',
      webserver_docroot => '/var/www/edeploy',
      state            => {'vm-centos' => '*', 'hp' => '4'},
}

# ------------
# Jenkins Part

package { ['python-jinja2',
            'python-paramiko',
            'python-libxml2',
            'libmysqlclient-dev',
            'libxml2-dev',
            'libxslt-dev',
            'libpq-dev',
            'python-dev',
            'python-virtualenv',
            'libffi-dev' ]:
      ensure => installed,
}

# -----------------
# PuppetMaster/PuppetDB Part

apt::source { 'debian_purpose':
  location          => 'http://ftp.us.debian.org/debian',
  release           => 'wheezy-proposed-updates',
  repos             => 'main contrib non-free',
  pin               => '-10',
  include_src       => true
}

class{ 'java':
    distribution => 'jre',
}

class{'puppet::repo::puppetlabs': }
Class['puppet::repo::puppetlabs'] -> Package <| |>

class { 'puppet::master': 
  storeconfigs => true,
  certname => 'installserver'
}
class { 'puppetdb': 
  ssl_listen_address => 'localhost',
}

class { 'puppetdb::master::config': 
  puppetdb_server => 'localhost',
}

