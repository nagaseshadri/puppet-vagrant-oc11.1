class eclipse ( $eclipse_gz_archive, $eclipse_source_gz_archive, $eclipse_tar_archive, $eclipse_install_dir, $eclipse_folder, $user, $group, $logoutput ) {

    $eclipse_home = "${eclipse_install_dir}/${eclipse_folder}"
    $temp_directory = hiera('temp_directory')

    require common

    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}" ]
    }

    if ( $::eclipse_installed == 'false' ) {
        exec { 'extract eclipse tar.gz':
            cwd => "${temp_directory}",
            command => "tar -xvf ${eclipse_source_gz_archive}"
        }
        ->
        exec { 'move eclipse':
            cwd => "${temp_directory}",
            command => "mv ${eclipse_folder} ${eclipse_home}",
            creates => "${eclipse_home}"
        }
        ->
        exec { 'fix eclipse permissions':
            cwd => "${temp_directory}",
            command => "chown -R ${user}:${group} ${eclipse_home}",
        }
        -> 
        exec { 'cleanup eclipse temp':
            cwd => "${temp_directory}",
            command => "rm -rf ${temp_directory}/${eclipse_gz_archive} ${temp_directory}/${eclipse_folder}"
        }
        
    }
    
    file { "/home/${user}/Desktop/Eclipse.desktop" :
        owner   => "${user}",
        mode    => 0777,
        content => template("${module_name}/Eclipse.desktop.erb")
    }  
}

