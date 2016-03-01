class weblogic::copydomain {

  require orawls::weblogic

  $default_params = {}
  
  $copy_domain_instances = hiera('copy_domain_instances', {})
  create_resources('orawls::copydomain',$copy_domain_instances, $default_params)
}

