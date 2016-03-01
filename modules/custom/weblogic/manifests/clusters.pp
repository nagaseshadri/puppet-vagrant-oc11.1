define weblogic::clusters::createStartStopScripts {

    $wls_user_name = hiera('orautils::wlsUserParam')
    $wls_password = hiera('orautils::wlsPasswordParam')
    $admin_hostname = hiera('adminserver_address')
    $admin_port = hiera('adminserver_port')
    $user = hiera('install_user')
    $group = hiera('install_group')
    $cluster_name = "${name}"

    file { "/opt/scripts/wls/start${name}.py":
      ensure  => present,
      content => template("${module_name}/startCluster.py.erb"),
      mode    => 0755,
      owner   => "${user}",
      group   => "${group}",
      require => File['/opt/scripts/wls']
    }
    ->
    file { "/opt/scripts/wls/stop${name}.py":
      ensure  => present,
      content => template("${module_name}/stopCluster.py.erb"),
      mode    => 0755,
      owner   => "${user}",
      group   => "${group}",
      require => File['/opt/scripts/wls']
    }    
}

class weblogic::clusters {

  require weblogic::datasources

  $default_params = {}
  
  $cluster_instances = hiera('cluster_instances', {})
  create_resources('wls_cluster',$cluster_instances, $default_params)

  $cluster_instance_keys = keys($cluster_instances)

  weblogic::clusters::createStartStopScripts {$cluster_instance_keys:} 
}


