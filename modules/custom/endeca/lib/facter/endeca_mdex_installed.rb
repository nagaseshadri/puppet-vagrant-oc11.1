Facter.add(:endeca_mdex_installed) do

  setcode do
    if File.exist?Facter.value(:oracle_root_install_directory) + '/endeca/MDEX/6.5.1/bin/dgraph'
      true
    else
      false
    end
    end
 end