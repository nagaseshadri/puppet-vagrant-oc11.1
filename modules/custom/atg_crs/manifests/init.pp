class atg_crs ( $atg_crs_archive , $atg_crs_install_config_file, $atg_crs_folder , $atg_crs_install_dir , $atg_crs_bin_file , $atg_crs_source_archive, $user, $group, $logoutput) {
    
    $atg_home = "${atg_crs_install_dir}/${atg_crs_folder}"
    $temp_directory = hiera('temp_directory')

    require common, java

    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}"]
    }

    if ( $::atg_crs_installed == 'false' ) {

        exec { 'extract atg crs zip':
            cwd => "${temp_directory}",
            command => "unzip -o ${atg_crs_source_archive}",
            creates => "${atg_home}/CommerceReferenceStore"
        }
        -> 
        file { "fix atg crs bin permissions" :
            ensure => "present",
            path => "${temp_directory}/${atg_crs_bin_file}",
            owner  => "${user}",
            mode   => 0755
        }
        ->
        file { "${temp_directory}/${atg_crs_install_config_file}" :
            owner   => "${user}",
            mode    => 0755,
            content => template("${module_name}/${atg_crs_install_config_file}.erb")
        }
        -> 
        file { 'atg crs install folder' :
            path => "${atg_crs_install_dir}",
            ensure => directory,
            owner => "${user}"
        }
        ->
        exec { 'execute atg crs bin':
            cwd => "${temp_directory}",
            timeout => 0,
            command => "${temp_directory}/./${atg_crs_bin_file} -f ${temp_directory}/${atg_crs_install_config_file} -i silent",
            logoutput => "${logoutput}",
            creates => "${atg_home}/CommerceReferenceStore"
        }
        ->
        exec { 'fix atg crs permissions':
            cwd => "${temp_directory}",
            timeout => 0,
            command => "chown -R ${user}:${group} ${atg_crs_install_dir}"
        }
        -> 
        exec { 'cleanup atg crs temp':
            cwd => "${temp_directory}",
            command => "rm -rf ${temp_directory}/${atg_crs_archive} ${temp_directory}/${atg_crs_bin_file} ${temp_directory}/${atg_crs_install_config_file}"
        }
       
    }
}
