require 'facter'

Facter.add(:atg_installed) do
    setcode do
        if File.exist?Facter.value(:oracle_root_install_directory) + '/atg/ATG11.1/home/bin/runAssembler'
            true
        else
            false
        end
    end
end