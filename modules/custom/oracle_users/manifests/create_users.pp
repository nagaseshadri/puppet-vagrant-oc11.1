
define oracle_users::create_users($sid, $user, $password) {
    $tablespace_name = "${user}_ts"
    $user_created = getvar("${user}_created")
    $tablespace_created = getvar("${tablespace_name}_created")
    # notify { "${user} ==> ${tablespace_name} ==> ${user_created} ==> ${tablespace_created}": }
    if ( $tablespace_created == undef or $tablespace_created == "false" ) {
        tablespace {"$sid/${tablespace_name}":
          ensure                    => present,
          datafile                  => "${tablespace_name}.DBF",
          size                      => 100M,
          logging                   => yes,
          autoextend                => on,
          next                      => 25M,
          max_size                  => 500M,
          extent_management         => local,
          segment_space_management  => auto
        }
    }
    if ( $user_created == undef or $user_created == "false" ) {
      oracle_user { "$sid/$user" :
          ensure      => present,
          temporary_tablespace      => temp,
          default_tablespace        => "${tablespace_name}",
          password    => "$password",
          grants      => ['ALL PRIVILEGES'],
          quotas      => {  "${tablespace_name}"  => 'unlimited' }
      }
    }
    if ( ($tablespace_created == undef or $tablespace_created == "false") and ( $user_created == undef or $user_created == "false" )) {
      Tablespace["$sid/${tablespace_name}"] -> Oracle_user["$sid/${user}"]
    }
}