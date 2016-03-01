newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  desc "The full specfied thread name"

  isnamevar

  to_translate_to_resource do | raw_resource|
    sid = raw_resource.column_data('SID')
    thread_no = raw_resource.column_data('THREAD#')
    "#{sid}/#{thread_no}"
  end

end

