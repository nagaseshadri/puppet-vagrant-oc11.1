define createDeployScripts( $app_name, $app_path, $cluster_name, $undeploy_timeout, $stage_mode) {

    $wls_user_name = hiera('orautils::wlsUserParam')
    $wls_password = hiera('orautils::wlsPasswordParam')
    $wls_weblogic_home_dir = hiera('wls_weblogic_home_dir')
    $admin_hostname = hiera('adminserver_address')
    $admin_port = hiera('adminserver_port')
    $user = hiera('install_user')
    $group = hiera('install_group')
    
    file { "/opt/scripts/wls/deploy${app_name}.py":
      ensure  => present,
      content => template("${module_name}/app_deploy.py.erb"),
      mode    => 0755,
      owner   => "${user}",
      group   => "${group}",
      require => File['/opt/scripts/wls']
    }
    -> 
    file { "/opt/scripts/wls/deploy${app_name}.sh":
      ensure  => present,
      content => template("${module_name}/deploy.sh.erb"),
      mode    => 0755,
      owner   => "${user}",
      group   => "${group}",
      require => File['/opt/scripts/wls']
    }  
}

class weblogic::deployments {

    require weblogic::clusters

    $default_params = {}
    $app_deploy_instances = hiera('app_deploy_instances', $default_params)

    create_resources ( createDeployScripts, $app_deploy_instances )

}
