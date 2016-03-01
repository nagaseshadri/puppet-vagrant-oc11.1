class weblogic::nodemanager {
    $wls12gVersion   = hiera('wls_version')
    $osWlHome    = $orautils::params::osWlHome
    $wlsDomainName   = hiera('domain_name')
	$logDir       = hiera('wls_log_dir')     

    # Refer https://github.com/biemond/biemond-orawls-vagrant/blob/master/puppet/manifests/site.pp

    require orawls::weblogic, weblogic::domains, weblogic::copydomain
    
    $default = {}
    
    $nodemanager_instances = hiera('nodemanager_instances', [])
    create_resources('orawls::nodemanager',$nodemanager_instances, $default)


}