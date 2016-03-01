require 'facter'

Facter.add(:root_install_directory) do
     setcode do
        fqdn = Facter.value(:fqdn)
        case fqdn
        when 'b2bbldenvdev.mch.moc.sgps'
          '/u01'
        else
          '/opt'
        end
    end
end

Facter.add(:oracle_root_install_directory) do
    setcode do
        fqdn = Facter.value(:fqdn)
        case fqdn
        when 'b2bbldenvdev.mch.moc.sgps'
          '/u01/oracle/product'
        else
          '/opt/oracle/product'
        end
    end
end

