class sqldeveloper ( $sqldeveloper_archive, $sqldeveloper_folder, $user, $group, $logoutput ) {

    $root_install_directory = hiera('root_install_directory')
    $sqldeveloper_home = "$root_install_directory/$sqldeveloper_folder"
    $sqldevConfigDir   = "/home/$user/.sqldeveloper"
  
  
  	$schemas= hiera('schemas')
    
    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin"]
    }

    if ( $::sqldeveloper_installed == 'false' ) {

        package { 'sqldeveloper':
            provider => 'rpm',
            ensure => installed, 
            allow_virtual => true,
            source => "${sqldeveloper_archive}"
        } 
        ->
        exec { 'fix sqldeveloper permissions':
            cwd => "${root_install_directory}",
            command => "chown -R ${user}:${group} ${sqldeveloper_home}"
        }
    }
    
   	   file { [ "${sqldevConfigDir}", "${sqldevConfigDir}/system4.0.3.16.84", "${sqldevConfigDir}/system4.0.3.16.84/o.jdeveloper.db.connection.12.1.3.2.41.140908.1359" ]:
	      ensure  => directory,
	      mode    => 755,
	      owner   => "${user}",
	      group   => "${group}",
	  }
	  ->
	  file { "${sqldevConfigDir}/system4.0.3.16.84/o.jdeveloper.db.connection.12.1.3.2.41.140908.1359/connections.xml":
	      ensure  => file,
	      mode    => 744,
	      content => template('sqldeveloper/connections.xml.erb'),
	      owner   => "${user}",
	      group   => "${group}",
	  }
    
}
