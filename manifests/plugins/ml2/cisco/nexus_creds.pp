#
# Configure the Mech Driver for cisco neutron plugin
# More info available here:
# https://wiki.openstack.org/wiki/Neutron/ML2/MechCiscoNexus
#
#
# neutron::plugins::ml2::cisco::nexus_creds used by
# neutron::plugins::ml2::cisco::nexus
#

define neutron::plugins::ml2::cisco::nexus_creds(
  $username,
  $password,
  $servers,
  $ip_address,
  $ssh_port,
  $nve_src_intf = undef,
  $physnet      = undef,
) {

  if ! defined(File['/var/lib/neutron/.ssh']) {
    file {'/var/lib/neutron/.ssh':
      ensure  => directory,
      owner   => 'neutron',
      #require => Package['neutron-server']
    }
  }

  # Test to make sure switch is reachable before ssh-keyscan
  exec {"ping_test_${name}":
    command => "/usr/bin/ping -c 5 ${ip_address}"
    user    => 'neutron'
  }

  exec {"nexus_creds_${name}":
    unless  => "/bin/cat /var/lib/neutron/.ssh/known_hosts | /bin/grep ${username}",
    command => "/usr/bin/ssh-keyscan -t rsa ${ip_address} >> /var/lib/neutron/.ssh/known_hosts",
    user    => 'neutron',
    require => [Exec["ping_test_${name}"]],
    #require => [Exec["ping_test_${name}"], Package['neutron-server'], File['/var/lib/neutron/.ssh']]
  }
}
