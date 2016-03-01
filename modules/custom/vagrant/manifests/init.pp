class vagrant ( $workspace_directory, $homepath, $user, $group) {

    require java
    
    $temp_directory = hiera('temp_directory')

    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin", "${temp_directory}"]
    }


    if( $hostname == 'localhost' ) {
      exec { 'fix vagrant home permissions':
          command => "chmod o+x /home/vagrant/",
      }
    }

    exec { "${workspace_directory}" :
        command => "mkdir -p ${workspace_directory}",
        creates => "${workspace_directory}"
    }
    ->
    file { 'Fix permissions ${workspace_directory}':
        ensure  => directory,
        path    => "${workspace_directory}",
        recurse => false,
        replace => false,
        mode    => 0755,
        owner   => $user,
        group   => $group,
    }
    ->
    oracle_exec {"ALTER SYSTEM SET PROCESSES=150 SCOPE=SPFILE":
        require => [ Class['oracle_xe'], Class['oracle_users'] ]
    }

    Class['oracle_xe'] -> Class['oracle_users']

    Class['java'] -> Class['orawls::weblogic']

    Class['orawls::weblogic'] -> Class['weblogic']

    Class['oracle_users'] -> Class['weblogic::datasources']
}
