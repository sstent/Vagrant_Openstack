node puppet {

 package { 
  'puppetlabs-release-6-7':
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


"/etc/puppet/autosign.conf":
  require => Package["puppet-server"],
  owner  => "root",
  group  => "root",
  mode   => 0644,
  content => "*";
}

service { "iptables":
        ensure => "stopped",
        enable => false;
        "puppetmaster":
        require => File["/etc/puppet/autosign.conf"],
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

package { 
  'puppetlabs-release-6-7':
     provider => 'rpm',
     ensure => installed,
     source => "http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm";
	'puppet':
		require => Package["puppetlabs-release-6-7"],
		ensure 		=> 'present';
}

host { 
    'puppet.vagrant.info':
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
