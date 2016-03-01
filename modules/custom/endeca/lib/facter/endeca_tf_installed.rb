Facter.add(:endeca_tf_installed) do

  setcode do
    if File.exist?Facter.value(:oracle_root_install_directory) + '/endeca/ToolsAndFrameworks/11.1.0/server/workspace/conf/ws-extensions.xml'
      true
    else
      false
    end
    end
 end