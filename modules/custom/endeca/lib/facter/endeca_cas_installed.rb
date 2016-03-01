Facter.add(:endeca_cas_installed) do

  setcode do
    if File.exist?Facter.value(:oracle_root_install_directory) + '/endeca/CAS/11.1.0/bin/cas-cmd.sh'
      true
    else
      false
    end
    end
 end