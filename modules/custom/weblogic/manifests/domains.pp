define weblogic::domains::copyjars {

    $jarstocopytodomainlibsrc = hiera('jarstocopytodomainlibsrc')
    $domain_directory = hiera('orautils::osDomainPathParam')
    $wls_os_user =  hiera('wls_os_user')
    
    file { "${domain_directory}/lib/${name}" :
        ensure => "present",
        source => "${jarstocopytodomainlibsrc}/${name}",
        owner  => "${wls_os_user}",
        mode   => 0755    
    }
}

class weblogic::domains {
    
    $jarstocopytodomainlib = hiera_array('jarstocopytodomainlib')

    require orawls::weblogic
    
    $default = {}
    
    $domain_instances = hiera('domain_instances', {})
    create_resources('orawls::domain',$domain_instances, $default)

    $wls_setting_instances = hiera('wls_setting_instances', {})
    create_resources('wls_setting',$wls_setting_instances, $default)
    
    copyjars { $jarstocopytodomainlib: }
}