module PhoneNumberUtils
  module_function

  def valid_mobile_number?(number)
    Phonelib.valid_for_country?(number, 'BR') &&
      Phonelib.parse(number).types.include?(:mobile)
  end

  def with_country_code(number)
    Phonelib.parse(number).e164.gsub(/^[+]/, '')
  end
end
