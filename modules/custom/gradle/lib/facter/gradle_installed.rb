require 'facter'

Facter.add(:gradle_installed) do
    setcode do
        if File.exist?Facter.value(:root_install_directory) + '/gradle/gradle-2.2/bin/gradle'
            true
        else
            false
        end
    end
end