class weblogic::machines {

  require weblogic::updatedomain
  
  $default_params = {}
  
  $machines_instances = hiera('machines_instances', {})
  create_resources('wls_machine',$machines_instances, $default_params)
  
}


