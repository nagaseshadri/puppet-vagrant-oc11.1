class weblogic::startwlsmanaged {
    
    require orawls::weblogic, orautils, weblogic::domains, weblogic::nodemanager, weblogic::startwlsadmin, weblogic::managedservers
    
    $default = {}
    
    $control_instances = hiera('managed_control_instances', {})
    create_resources('orawls::control',$control_instances, $default)
    
}