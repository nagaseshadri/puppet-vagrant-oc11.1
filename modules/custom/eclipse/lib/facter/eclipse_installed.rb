Facter.add(:eclipse_installed) do

  setcode do
    if File.exist?Facter.value(:root_install_directory) + '/eclipse/eclipse'
      true
    else
      false
    end
    end
 end