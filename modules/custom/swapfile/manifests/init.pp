class swapfile ( $filepath, $filesize, $logoutput ) {

    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin"]
    }
    
    if ( $::swap_installed == 'false' ) {

        # file_line is a type defined in stdlib module not puppet OOTB
        
        file_line { "swap_fstab_line_${filepath}":
            ensure  => present,
            line    => "${filepath} swap swap defaults 0 0",
            path    => "/etc/fstab",
            match   => "${filepath}"
        }

        exec { 'Create swap file':
          command => "/bin/dd if=/dev/zero of=${filepath} bs=2048 count=${filesize}",
          creates => $filepath,
          logoutput => "${logoutput}"
        }
        
        exec { 'Attach swap file':
          command => "/sbin/mkswap ${filepath} && /sbin/swapon ${filepath}",
          require => Exec['Create swap file'],
          unless  => "/sbin/swapon -s | grep ${filepath}",
          logoutput => "${logoutput}"
        }
        
    }
}
