class weblogic::startwlsadmin {
    
    require orawls::weblogic, weblogic::domains, weblogic::nodemanager
    
    $default = {}
    
    $control_instances = hiera('admin_control_instances', {})
    create_resources('orawls::control',$control_instances, $default)
    
}