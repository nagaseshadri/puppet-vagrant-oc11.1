result = Facter::Core::Execution.exec('echo "select tablespace_name from user_tablespaces;" | sqlplus -s sys/password as sysdba')
tablespaces = result.split(/\n/).reject(&:empty?)
for tablespace in tablespaces
    if tablespace.start_with?("ATG")    
        Facter.add("#{tablespace}_created") do
            setcode do
                true
            end
        end
    end
end 

result = Facter::Core::Execution.exec('echo "select username from all_users;" | sqlplus -s sys/password as sysdba')
users = result.split(/\n/).reject(&:empty?)
for user in users
    if user.start_with?("ATG")    
        Facter.add("#{user}_created") do
            setcode do
                true
            end
        end
    end
end 

