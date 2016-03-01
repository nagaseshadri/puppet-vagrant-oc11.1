class weblogic::managedservers {

  require weblogic::startwlsadmin, weblogic::machines, orautils

  $default_params = {}
  $server_instances = hiera('server_instances', {})
  create_resources('wls_server',$server_instances, $default_params)

}