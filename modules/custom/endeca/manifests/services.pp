class endeca::services ( $cas_root, $cas_workspace, $tf_home, $mdex_home, $ps_install_dir, $user ) {

    $endeca_user = "${user}"
    
    require endeca::cas, endeca::tf, endeca::ps
    
    file { "/etc/init.d/endeca_tf" :
        owner   => "${user}",
        mode    => 0755,
        content => template("${module_name}/endeca_tf.erb")
    }            
    ->
    service { "endeca_tf" :
        ensure    => "running",
        enable    => true,
        path      => "/etc/init.d",
        require   => File[ "/etc/init.d/endeca_tf" ],
        hasstatus => false
    } 
    ->
    file { "/etc/init.d/endeca_ps" :
        owner   => "${user}",
        mode    => 0755,
        content => template("${module_name}/endeca_ps.erb")
    }            
    ->
    service { "endeca_ps" :
        ensure    => "running",
        enable    => true,
        path      => "/etc/init.d",
        require   => File[ "/etc/init.d/endeca_ps" ],
        hasstatus => false
    }  
    ->
    file { "/etc/init.d/endeca_cas" :
        owner   => "${user}",
        mode    => 0755,
        content => template("${module_name}/endeca_cas.erb")
    }
    ->  
    service { "endeca_cas" :
        ensure    => "running",
        enable    => true,
        path      => "/etc/init.d",
        require   => File[ "/etc/init.d/endeca_cas" ],
        hasstatus => false
    }     
}

