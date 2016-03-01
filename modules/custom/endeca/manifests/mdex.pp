class endeca::mdex ( $mdex_archive, $mdex_source_archive, $mdex_install_dir, $mdex_version, $install_dir, $mdex_sh_file, $presApi_tgz_file, $user, $group, $logoutput ) {

    $mdex_home = "${mdex_install_dir}/${mdex_version}"
    $temp_directory = hiera('temp_directory')

    require common

    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}"]
    }

    if $::endeca_mdex_installed == 'false' {

        exec { 'extract mdex zip':
            cwd => "${temp_directory}",
            command => "unzip -o ${mdex_source_archive}",
            creates => "${temp_directory}/${mdex_sh_file}",
        }
        ->
        file { "fix mdex sh permissions" :
            path => "${temp_directory}/${mdex_sh_file}",
            owner  => "${user}",
            mode   => 0755,
        }
        ->
        exec { 'execute mdex sh':
            cwd => "${temp_directory}",
            timeout => 0,       
            command => "./${mdex_sh_file} --target ${install_dir}",
            logoutput => "${logoutput}",
            creates => "${mdex_home}",
        }
        ->
        exec { 'fix mdex permissions':
            cwd => "${temp_directory}",
            command => "chown -R ${user}:${user} ${install_dir}/endeca",
        }
        -> 
        exec { 'cleanup mdex temp':
            cwd => "${temp_directory}",
            command => "rm -rf ${temp_directory}/${mdex_archive} ${temp_directory}/${mdex_sh_file} ${temp_directory}/${presApi_tgz_file}"
        }
        ->
        file { "/etc/profile.d/mdex.sh":
          content => "source ${mdex_home}/mdex_setup_sh.ini\n"
        }
        
    }
}
