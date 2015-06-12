class neutron::plugins::ml2::cisco::cisco_ml2 (
  $package_ensure = 'present'
) {
  include ::neutron::params
  require ::neutron::plugins::ml2

  #package {'neutron-plugin-cisco-ml2':
  #  ensure => $package_ensure,
  #  name   => $::neutron::params::cisco_ml2_server_package,
  #  tag    => 'openstack',
  #}

  #Neutron_plugin_ml2<||> ->
  #concat { $::neutron::params::cisco_ml2_config_file:
  #  owner => 'root',
  #  group => 'root',
  #} ~> Service['neutron-server']

  concat { $::neutron::params::cisco_ml2_config_file:
    owner => 'root',
    group => 'root',
  }
}
