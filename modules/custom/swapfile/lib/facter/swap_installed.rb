Facter.add(:swap_installed) do

  setcode do
    if File.exist?'/home/swapfile'
      true
    else
      false
    end
    end
 end