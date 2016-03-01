class endeca::tf ( $tf_archive, $tf_source_archive, $tf_version, $tf_install_dir, $install_dir, $tf_unzip_root_dir, $tf_unzip_contents, $tf_sh_file, $tf_silent_response_file, $tf_oracle_home_key, $tf_admin_password, $user, $group, $logoutput) {

    $tf_home = "${tf_install_dir}/${tf_version}"
    $temp_directory = hiera('temp_directory')
    $oracle_home = hiera('oracle_products_install_directory')
    $endeca_user = "${user}"
    
    require common
    
    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}"]
    }

    if ( $::endeca_tf_installed == 'false' ) {

        exec { 'extract tf zip':
            cwd => "${temp_directory}",
            command => "unzip -o ${tf_source_archive}",
            creates => "${tf_unzip_contents}",
        }
        ->    
        exec { 'fix tf unzip content permissions':
            cwd => "${temp_directory}",
            command => "chown -R ${user}:${group} ${tf_unzip_root_dir}",
        }
        ->
        exec { 'fix tf sh execute permissions':
            cwd => "${temp_directory}",
            command => "chmod 755 ${tf_unzip_contents}/./${tf_sh_file}",
        }
        ->
        file { "${temp_directory}/${tf_silent_response_file}" :
            owner   => "${user}",
            mode    => 0755,
            content => template("${module_name}/${tf_silent_response_file}.erb")
        }        
        ->
        file { "${tf_install_dir}" :
            ensure => directory,
            owner => "${user}",
            group => "${group}",
            mode => 0755
        }
        ->
        exec { 'execute tf sh':
            cwd => "${temp_directory}",
            timeout => 0,
            command => "su - ${user} -c '${tf_unzip_contents}/./${tf_sh_file} ${temp_directory}/${tf_silent_response_file} ${tf_oracle_home_key} ${tf_install_dir} ${tf_admin_password}'",
            creates => "${tf_home}",
            logoutput => "${logoutput}"
        }
        ->
        exec { 'fix tf permissions':
            cwd => "${temp_directory}",
            command => "chown -R ${user}:${group} ${install_dir}/endeca",
        }
        -> 
        exec { 'cleanup tf temp':
            cwd => "${temp_directory}",
            command => "rm -rf ${temp_directory}/${tf_archive} ${tf_unzip_root_dir} ${temp_directory}/${tf_silent_response_file}"
        }
        ->
        file { "/etc/profile.d/tf.sh":
          content => "export ENDECA_TOOLS_ROOT=${tf_home}\nexport ENDECA_TOOLS_CONF=${tf_home}/server/workspace\n"
        }
    } 
}


