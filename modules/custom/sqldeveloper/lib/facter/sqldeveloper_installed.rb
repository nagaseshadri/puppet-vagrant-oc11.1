require 'facter'

Facter.add(:sqldeveloper_installed) do
    setcode do
        if File.exist?Facter.value(:root_install_directory) + '/sqldeveloper/sqldeveloper.sh'
            true
        else
            false
        end
    end
end