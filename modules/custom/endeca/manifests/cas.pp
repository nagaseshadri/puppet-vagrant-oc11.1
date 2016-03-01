class endeca::cas ( $cas_archive, $cas_source_archive, $cas_version, $install_dir, $cas_install_dir, $install_config_ini, $endeca_tools_root, $endeca_tools_conf, $cas_sh_file, $cas_server_port, $cas_shutdown_port, $cas_server_host, $user, $group, $logoutput ) {

    $cas_home = "${cas_install_dir}/${cas_version}"
    $temp_directory = hiera('temp_directory')
    $endeca_user = "${user}"
    $cas_root = "${cas_home}"
    $cas_workspace = "${cas_home}/../workspace"

    require common, endeca::tf
    
    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}" ]
    }

    if ( $::endeca_cas_installed == 'false' ) {

        exec { 'extract cas zip':
            cwd => "${temp_directory}",
            command => "unzip -o ${cas_source_archive}",
            creates => "/tmp/${cas_sh_file}",
        }
        ->
        exec { "fix cas sh permissions" :
            cwd => "${temp_directory}",
            command => "chmod 755 ${temp_directory}/${cas_sh_file}"
        }
        ->
        file { "${cas_install_dir}" :
            ensure => directory,
            owner => "${user}",
            group => "${user}",
            mode => 0755
        }   
        ->
        file { "${temp_directory}/${install_config_ini}" :
            owner   => "${user}",
            mode    => 0755,
            content => template("${module_name}/${install_config_ini}.erb")
        }               
        ->
        exec { 'execute cas sh':
            cwd => "${temp_directory}",
            timeout => 0,
            command => "./${cas_sh_file} --silent --target ${install_dir} --endeca_tools_root ${endeca_tools_root} --endeca_tools_conf ${endeca_tools_conf} < ${temp_directory}/${install_config_ini}",
            logoutput => "${logoutput}",
            creates => "${cas_home}",
        }
        ->
        exec { 'fix cas permissions':
            cwd => "${temp_directory}",
            command => "chown -R ${user}:${group} ${install_dir}/endeca"
        }  
        -> 
        exec { 'cleanup cas temp':
            cwd => "${temp_directory}",
            command => "rm -rf ${temp_directory}/${cas_archive} ${temp_directory}/${cas_sh_file} ${temp_directory}/${install_config_ini}"
        }
        file { "/etc/profile.d/cas.sh":
          content => "export CAS_ROOT=${cas_home}\n"
        }
    }
}
