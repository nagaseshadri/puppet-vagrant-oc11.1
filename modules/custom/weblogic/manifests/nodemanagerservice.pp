class weblogic::nodemanagerservice {
    $wls12gVersion   = hiera('wls_version')
    $wlsDomainName   = hiera('domain_name')
	$logDir       = hiera('wls_log_dir')     
  	$osWlHome     = hiera('wls_weblogic_home_dir')
    $domainPath = hiera('orautils::osDomainPathParam')
  orautils::nodemanagerautostart{"autostart ${wlsDomainName}":
    version     => "$wls12gVersion",
    wlHome      => $osWlHome, 
    domainPath  => $domainPath,
    user        =>'vagrant',
    domain      => $wlsDomainName,
    logDir      => $logDir,
    }
}