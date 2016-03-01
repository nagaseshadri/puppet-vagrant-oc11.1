class java ( $java_archive , $java_install_dir , $java_folder , $java_source_archive, $user, $group, $logoutput ) {

    $java_home = "${java_install_dir}/${java_folder}"
    $temp_directory = hiera('temp_directory')

    require common
    
    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}" ]
    }

    if ( $::java_installed == 'false' ) {

        exec { 'extract jdk':
            cwd => "${temp_directory}",
            command => "tar -xvf ${java_source_archive}",
            creates => "${java_home}/bin/java",
        }
        ->
        file { "${java_install_dir}" :
            ensure => directory,
            owner => $user
        }
        ->
        exec { 'move jdk':
            cwd => "${temp_directory}",
            creates => "${java_home}",
            command => "mv ${java_folder} ${java_install_dir}"
        }
        ->
        exec { 'fix permissions':
            cwd => "${temp_directory}",
            command => "chown -R ${user}:${group} ${java_install_dir}"
        }
        -> 
        exec { 'cleanup java temp':
            cwd => "${temp_directory}",
            command => "rm -rf ${temp_directory}/${java_archive}"
        }
    }
    file { "/etc/profile.d/java.sh":
      content => "export JAVA_HOME=${java_home} \nexport PATH=\$JAVA_HOME/bin:\$PATH \nexport JAVA_VM=\$JAVA_HOME/bin/java \nexport ATGJRE=\$JAVA_VM"
    }
}


