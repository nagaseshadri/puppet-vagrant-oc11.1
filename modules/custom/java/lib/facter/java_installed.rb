require 'facter'

Facter.add(:java_installed) do
    setcode do
        if File.exist?Facter.value(:oracle_root_install_directory) + '/java/jdk1.7.0_55/bin/javac'
            true
        else
            false
        end
    end
end