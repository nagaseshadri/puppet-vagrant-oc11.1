class weblogic {
    # Refer https://github.com/biemond/biemond-orawls-vagrant/blob/master/puppet/manifests/site.pp

    require java, orawls::weblogic, orautils
    
    include weblogic::domains
    include weblogic::copydomain
    include weblogic::nodemanager
    include weblogic::startwlsadmin
    include weblogic::updatedomain
    include weblogic::machines
    include weblogic::managedservers
    include weblogic::datasources
    include weblogic::clusters
    include weblogic::deployments
    include weblogic::packdomain
    include weblogic::nodemanagerservice
}