class weblogic::packdomain {

  require weblogic::datasources

  $default_params = {}

  $pack_domain_instances = hiera('pack_domain_instances', $default_params)
  create_resources('orawls::packdomain',$pack_domain_instances, $default_params)

}

