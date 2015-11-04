require 'phone_number_utils'
class InlineSmsRequest
  include ActiveModel::Model
  include PhoneNumberUtils

  attr_accessor :phone_numbers
  attr_accessor :message
  attr_accessor :user

  validates :message,
    presence: true,
    length: { within: 2..500 }
  validates :phone_numbers, presence: true
  validates :user, presence: true

  validate :phone_list_validation
  #  def initialize(attributes = {})
  #    attributes.each do |name, value|
  #      send("#{name}=", value)
  #    end
  #  end

  def save
    if valid?
      Transmissions::InlineSmsRequestService.new.create(self, user)
    else
      false
    end
  end

  def parsed_phone_list
    phone_numbers.split(/[^0-9]+/).sort.uniq
  end

  def phone_list_validation
    parsed_list = parsed_phone_list
    if parsed_list.empty?
      errors.add(:phone_numbers, "no valid phone number")
      return false
    end

    parsed_list.each do |number|
      errors.add(:phone_numbers, "invalid phone number given: '#{number}'") unless valid_mobile_number?(number)
    end
  end
end
