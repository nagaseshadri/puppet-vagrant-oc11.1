class common {

    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin"]
    }
    $software_mount = hiera('software_mount')
    $temp_directory = hiera('temp_directory')
    $root_install_directory = hiera('root_install_directory')
    $oracle_products_install_directory = hiera('oracle_products_install_directory')
    $install_user = hiera('install_user')
    $install_group = hiera('install_group')

    file { "${software_mount}" :
        ensure => directory
    }
    ->
    user {"${install_user}" :
        ensure => present,
        managehome => true
    }
    ->
    group {"${install_group}" :
        ensure => present
    }
    ->
    exec {"${temp_directory}" :
        command => "mkdir -p ${temp_directory}",
        creates => "${temp_directory}"
    }
    ->
    exec { "${root_install_directory}" :
        command => "mkdir -p ${root_install_directory}",
        creates => "${root_install_directory}"
    }
    ->
    exec { "${oracle_products_install_directory}" :
        command => "mkdir -p ${oracle_products_install_directory}",
        creates => "${oracle_products_install_directory}"
    }
    ->
    exec { 'yum-clean-expire-cache':
        command => '/usr/bin/yum clean expire-cache',
        refreshonly => true,
    }
    ->
    package { "libaio" :
        ensure  => latest,
        allow_virtual => true,
        require => Exec['yum-clean-expire-cache']
    }
    ->
    file { "/etc/profile.d/facters.sh":
        ensure => present
    }
}
