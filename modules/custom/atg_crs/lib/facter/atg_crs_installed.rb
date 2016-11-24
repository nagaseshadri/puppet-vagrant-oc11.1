require 'facter'

Facter.add(:atg_crs_installed) do
    setcode do
        if File.exist?Facter.value(:oracle_root_install_directory) + '/atg/ATG11.1/CommerceReferenceStore/installconfig/config.xml'
            true
        else
            false
        end
    end
end