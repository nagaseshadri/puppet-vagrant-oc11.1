class endeca::ps ( $ps_archive, $ps_source_archive, $ps_version, $ps_install_dir, $ps_bin_file, $install_dir, $install_config_ini, $http_service_listen_port, $http_service_shutdown_port, $mdex_home, $user, $group, $logoutput) {

    $ps_home = "${ps_install_dir}/${ps_version}"
    $temp_directory = hiera('temp_directory')
    $endeca_user = "${user}"
    
    require common, endeca::mdex
    
    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}"]
    }

    if ( $::endeca_ps_installed == 'false' ) {

        exec { 'extract ps zip':
            cwd => "${temp_directory}",
            command => "unzip -o ${ps_source_archive}",
            creates => "${temp_directory}/${ps_bin_file}",
        }
        ->
        file { "fix ps bin permissions" :
            path => "${temp_directory}/${ps_bin_file}",
            owner  => "${user}",
            mode   => 0755,
        }
        ->
        file { "${temp_directory}/${install_config_ini}" :
            owner   => "${user}",
            mode    => 0755,
            content => template("${module_name}/${install_config_ini}.erb")
        }        
        -> 
        exec { 'execute ps bin':
            cwd => "${temp_directory}",
            command => "./${ps_bin_file} --target ${install_dir} < ${temp_directory}/${install_config_ini}",
            timeout => 0,
            logoutput => "${logoutput}",
            creates => "${ps_home}",
        }
        ->
        exec { 'fix ps permissions':
            cwd => "${temp_directory}",
            command => "chown -R ${user}:${group} ${install_dir}/endeca",
        }        
        -> 
        exec { 'cleanup ps temp':
            cwd => "${temp_directory}",
            command => "rm -rf ${temp_directory}/${ps_archive} ${temp_directory}/${ps_bin_file} ${temp_directory}/${install_config_ini}"
        }
        ->
        file { "/etc/profile.d/ps.sh":
          content => "source ${ps_install_dir}/workspace/setup/installer_sh.ini\n"
        }
    }   
}
