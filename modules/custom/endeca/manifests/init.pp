class endeca ( $endeca_home, $apps_folder_path, $user, $group ) {

    require common
    
    file {["${endeca_home}","${apps_folder_path}"]:
        ensure => directory,
        owner => "${user}",
        group => "${group}",
        mode => 0755
    }

    include endeca::mdex
    include endeca::cas
    include endeca::tf
    include endeca::ps
    include endeca::services
    
}