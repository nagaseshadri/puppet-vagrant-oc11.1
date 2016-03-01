newproperty(:compat_rdbms) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc "The compatible rdbms attribute of the diskgroup"

  to_translate_to_resource do | raw_resource|
    raw_resource.column_data('DATABASE_COMPATIBILITY').upcase
  end

end
