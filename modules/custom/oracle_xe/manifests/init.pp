class oracle_xe ( $oracle_xe_zip, $oracle_xe_source_zip, $oracle_xe_rpm, $oracle_xe_unzip_contents, $oracle_xe_install_dir, $install_config_file, $http_port, $db_port, $sys_password, $start_on_startup, $user, $group, $logoutput) {
    
    $temp_directory = hiera('temp_directory')

    require common, swapfile
    
    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}"]
    }

    if ( $::oracle_xe_installed == 'false' ) {
        exec { 'extract oracle xe':
            cwd => "${temp_directory}",
            command => "unzip -o ${oracle_xe_source_zip}"
        }  
        ->
        exec { 'execute oracle rpm install':
            cwd => "${temp_directory}",
            command => "rpm -ivh ${oracle_xe_unzip_contents}/${oracle_xe_rpm}",
            timeout => 0,
            logoutput => "${logoutput}"
        }
        ->
        file { "${temp_directory}/${install_config_file}" :
            owner   => "${user}",
            mode    => 0755,
            content => template("${module_name}/${install_config_file}.erb")
        }           
        ->
        exec { 'configure oracle xe':
            cwd => "${temp_directory}",
            command => "/etc/init.d/oracle-xe configure < ${temp_directory}/${install_config_file}",
            timeout => 0,
            logoutput => "${logoutput}"
        }
        -> 
        exec { 'cleanup oracle temp':
            cwd => "${temp_directory}",
            command => "rm -rf ${temp_directory}/${oracle_xe_zip} ${temp_directory}/${oracle_xe_unzip_contents} ${temp_directory}/${install_config_file}"
        }
        ->
        file { "/etc/profile.d/oracle-xe.sh":
          content => ". ${oracle_xe_install_dir}/bin/oracle_env.sh"
        }
        
    }
}
