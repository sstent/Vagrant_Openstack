node puppet {

	#ensure git is installed
 package { 'puppetlabs-release-6-7':
     provider => 'rpm',
     ensure => installed,
     source => "http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm";
    'git':
		ensure 		=> 'present';
	'puppet-server':
		require => Package["puppetlabs-release-6-7"],
		ensure 		=> 'present';
  'rubygem-rake':
    ensure  => 'present';
	}




vcsrepo { '/etc/puppet/modules/openstack':
  require => Package["puppet-server"],
  ensure   => latest,
  provider => git,
  source   => 'https://sstent:farscape5@github.com/stratustech/puppet-openstack.git',
  notify   => File["/etc/puppet/modules/openstack"];
'/etc/puppet/manifests':
  require => [Package["puppet-server"],File['/etc/puppet/manifests']],
  ensure   => latest,
  provider => git,
  source   => 'https://sstent:farscape5@github.com/stratustech/POC_ALPHA.git';
  '/etc/puppet/modules/rabbitmq':
  require => Package["puppet-server"],
  ensure   => latest,
  provider => git,
  source   => 'https://github.com/gergnz/puppetlabs-rabbitmq.git';
  '/etc/puppet/modules/horizon':
  require => Package["puppet-server"],
  ensure   => latest,
  provider => git,
  source   => 'https://sstent:farscape5@github.com/stratustech/puppet-horizon.git';
 }

file { "/etc/puppet/modules/openstack":
  require => Package["puppet-server"],
  ensure => "directory",
  owner  => "root",
  group  => "root",
  mode   => 755,
  recurse => true,
  notify  => Exec["sudo rake modules:clone"];
"/etc/puppet/manifests":
  require => Package["puppet-server"],
  before => Vcsrepo['/etc/puppet/manifests'],
  force => true,
  backup => false,
  ensure => "absent";
"/etc/puppet/autosign.conf":
  require => Package["puppet-server"],
  owner  => "root",
  group  => "root",
  mode   => 0644,
  content => "*";
}

exec {"sudo rake modules:clone":
			require => [Package["rubygem-rake"],Vcsrepo['/etc/puppet/modules/horizon','/etc/puppet/modules/rabbitmq','/etc/puppet/manifests','/etc/puppet/modules/openstack']],
			cwd => "/etc/puppet/modules/openstack",
			path => ["/usr/local/bin","/bin","/usr/bin","/usr/local/sbin","/usr/sbin","/sbin","/home/vagrant/bin"];
		}

service { "iptables":
        ensure => "stopped",
        enable => false;
        "puppetmaster":
        require => [File["/etc/puppet/autosign.conf"],Exec["sudo rake modules:clone"]],
        ensure => "running",
        enable => true;
      }
        
host { 'controller.vagrant.info':
    ip => '192.168.33.11',
    host_aliases => 'controller';
    'compute1.vagrant.info':
    ip => '192.168.33.12',
    host_aliases => 'compute1';
  }


}



node controller {

	#ensure git is installed
 package { 'puppetlabs-release-6-7':
     provider => 'rpm',
     ensure => installed,
     source => "http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm";
	'puppet':
		require => Package["puppetlabs-release-6-7"],
		ensure 		=> 'present';
	}

service { "iptables":
        ensure => "stopped",
        enable => false;
        "puppet":
        require => Package["puppet"],
        ensure => "running",
        enable => true;
      }



host { 'puppet.vagrant.info':
    ip => '192.168.33.10',
    host_aliases => 'puppet';
    'compute1.vagrant.info':
    ip => '192.168.33.12',
    host_aliases => 'compute1';
  }


}


node compute1 {

  #ensure git is installed
 package { 'puppetlabs-release-6-7':
     provider => 'rpm',
     ensure => installed,
     source => "http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm";
  'puppet':
    require => Package["puppetlabs-release-6-7"],
    ensure    => 'present';
  }

service { "puppet":
        require => Package["puppet"],
        ensure => "running",
        enable => true;
      }



host { 'puppet.vagrant.info':
    ip => '192.168.33.10',
    host_aliases => 'puppet';
       'controller.vagrant.info':
    ip => '192.168.33.11',
    host_aliases => 'controller';
}


}
