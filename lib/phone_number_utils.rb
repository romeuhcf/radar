module PhoneNumberUtils
  module_function

  def valid_mobile_number?(number)
    Phonelib.valid_for_country?(number, 'BR') &&
      Phonelib.parse(number).types.include?(:mobile)
  end
end
