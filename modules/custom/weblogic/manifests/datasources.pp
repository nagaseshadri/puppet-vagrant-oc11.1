class weblogic::datasources {

    require weblogic::startwlsadmin, weblogic::managedservers

    $default = {}

    $datasource_instances = hiera('datasource_instances', {})
    create_resources('wls_datasource',$datasource_instances, $default)
    
}