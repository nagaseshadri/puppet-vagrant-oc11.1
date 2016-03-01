newproperty(:compat_asm) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc "The compatible asm attribute of the diskgroup"

  to_translate_to_resource do | raw_resource|
    raw_resource.column_data('COMPATIBILITY').upcase
  end

end
