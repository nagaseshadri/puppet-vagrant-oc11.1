class gradle ( $gradle_archive, $gradle_install_dir, $gradle_folder, $gradle_source_archive, $user, $group, $logoutput) {
    
    $gradle_home = "${gradle_install_dir}/${gradle_folder}"
    $temp_directory = hiera('temp_directory')

    require common

    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}" ]
    }

    if ( $::gradle_installed == 'false' ) {

        exec { 'extract gradle':
            cwd => "${temp_directory}",
            command => "unzip -o ${gradle_source_archive}",
            creates => "${gradle_home}"
        }
        ->
        file { "${gradle_install_dir}":
            ensure => directory,
            owner => "${user}"
        }
        ->
        exec { 'move gradle':
            cwd => "${temp_directory}",
            creates => "${gradle_home}",
            require => File["${gradle_install_dir}"],
            command => "mv ${gradle_folder} ${gradle_install_dir}"
        }
        ->
        exec { 'fix gradle permissions':
            cwd => "${temp_directory}",
            command => "chown -R ${user}:${group} ${gradle_install_dir}"
        }
        -> 
        exec { 'cleanup gradle temp':
            cwd => "${temp_directory}",
            command => "rm -rf ${temp_directory}/${gradle_archive}"
        }
        ->
        file { "/etc/profile.d/gradle.sh":
          content => "export GRADLE_HOME=${gradle_home} \nexport PATH=\$PATH:\$GRADLE_HOME/bin \n"
        }
    
    }
}
