newparam(:name) do
  include EasyType
  include EasyType::Validators::Name

  desc "The full diskgroup name including SID"

  isnamevar

  to_translate_to_resource do | raw_resource|
    sid = raw_resource.column_data('SID')
    diskgroup_name = raw_resource.column_data('NAME').upcase
    "#{sid}/#{diskgroup_name}"
  end


end
