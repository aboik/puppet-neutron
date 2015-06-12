#
# Configure the Nexus VXLAN Type Driver
# More info available here:
# http://docwiki.cisco.com/wiki/OpenStack/ML2NexusMechanismDriver
#
# === Parameters
#

class neutron::plugins::ml2::cisco::type_nexus_vxlan (
  $vni_ranges = undef,
  $mcast_ranges
) {
  # Evaluate the cisco_ml2 class after this class
  include neutron::plugins::ml2::cisco::cisco_ml2
  #include neutron::plugins::ml2::cisco::nexus

  concat::fragment { 'type_nexus_vxlan_config':
    target  => $::neutron::params::cisco_ml2_config_file,
    content => template('neutron/ml2_conf_cisco_type_nexus_vxlan.erb') 
  }
}

