Facter.add(:oracle_xe_installed) do

  setcode do
    if File.exist?'/u01/app/oracle/product/11.2.0/xe'
      true
    else
      false
    end
    end
 end