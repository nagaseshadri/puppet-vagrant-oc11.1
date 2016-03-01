class weblogic::updatedomain {

  require weblogic::startwlsadmin
  
  $default_params = {}

  $wls_domain_instances = hiera('wls_domain_instances', {})
  create_resources('wls_domain',$wls_domain_instances, $default_params)
  
}


