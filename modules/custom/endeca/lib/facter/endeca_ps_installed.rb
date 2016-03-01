Facter.add(:endeca_ps_installed) do

  setcode do
    if File.exist?Facter.value(:oracle_root_install_directory) + '/endeca/PlatformServices/11.1.0/bin/eaccmd.sh'
      true
    else
      false
    end
    end
 end