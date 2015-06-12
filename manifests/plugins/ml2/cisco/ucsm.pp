#
# Configure the Mech Driver for cisco UCSM plugin
#
# === Parameters
#

class neutron::plugins::ml2::cisco::ucsm (
  $ucsm_ip,
  $ucsm_username,
  $ucsm_password,
  $supported_pci_devs = undef,
  $ucsm_host_list,
) {
  include neutron::plugins::ml2::cisco::cisco_ml2

  concat::fragment { 'ucsm_config':
    target  => $::neutron::params::cisco_ml2_config_file,
    content => template('neutron/ml2_conf_cisco_ucsm.erb')
  }
}

