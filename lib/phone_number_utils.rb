module PhoneNumberUtils
  module_function

  def valid_mobile_number?(number)
    Phonelib.valid_for_country?(number, 'BR') &&
      Phonelib.parse(number).types.include?(:mobile)
  end

  def with_country_code(number)
    Phonelib.parse(number).e164.gsub(/^[+]/, '')
  end

  def remove_country_prefix(num)
    if num =~ /\A55[0-9]{10,11}\z/
      num.gsub(/^55/, '')
    else
      num
    end
  end

end
