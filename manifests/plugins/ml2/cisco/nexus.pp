#
# Configure the Mech Driver for cisco neutron plugin
# More info available here:
# https://wiki.openstack.org/wiki/Neutron/ML2/MechCiscoNexus
#
# === Parameters
#
# [*neutron_config*]
# Neutron switch configuration for ml2_cisco_conf.ini
# Example nexus config format:
#  { 'switch_hostname' => {'username' => 'admin',
#    'ssh_port' => 22,
#    'password' => "password",
#    'ip_address' => "172.18.117.28",
#    'servers' => {
#      'control01' => "portchannel:20",
#      'control02' => "portchannel:10"
#    }}}
#

class neutron::plugins::ml2::cisco::nexus (
  $nexus_config       = undef,
  $vlan_name_prefix          = 'q-',
  $svi_round_robin           = false,
  $managed_physical_network  = undef,
  $provider_vlan_name_prefix = 'p-',
  $persistent_switch_config  = false,
  $switch_heartbeat_time     = 0,
  $switch_replay_count       = 3,
  $provider_vlan_auto_create = True,
  $provider_vlan_auto_trunk  = True,
  $vxlan_global_config       = True,
  $host_key_checks           = False
) {
  # Evaluate the cisco_ml2 class after this class
  include neutron::plugins::ml2::cisco::cisco_ml2
  Class['nexus'] -> Class['cisco_ml2']

  if !$nexus_config {
    fail('No nexus config specified')
  }

  # For Ubuntu: This package is not available upstream
  # Please use the source from:
  # https://launchpad.net/~cisco-openstack/+archive/python-ncclient
  # and install it manually
  package { 'python-ncclient':
    ensure => installed,
    tag    => 'openstack',
  } ~> Service['neutron-server']

  concat::fragment { 'nexus_config':
    target  => $::neutron::params::cisco_ml2_config_file,
    content => template('neutron/ml2_conf_cisco_nexus.erb')
  }

  create_resources(neutron::plugins::ml2::cisco::nexus_creds, $nexus_config)

}

