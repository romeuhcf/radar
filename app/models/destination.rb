#------------------------------------------------------------------------------
# Destination
#
# Name            SQL Type             Null    Default Primary
# --------------- -------------------- ------- ------- -------
# id              int(11)              false           true
# kind            varchar(255)         true            false
# address         varchar(255)         true            false
# contacted_times int(11)              true            false
# last_used_at    date                 true            false
# created_at      datetime             false           false
# updated_at      datetime             false           false
#
#------------------------------------------------------------------------------
require 'phone_number_utils'
class Destination < ActiveRecord::Base
  has_many :messages
  has_many :chat_rooms
  before_validation :canonicalize_address
  validates :address, presence: true
  validate :check_mobile_number

  def last_outgoing_sent_message
    messages.where(transmission_state: 'sent').order('sent_at DESC').first
  end

  def self.canonicalize_address(address)
    Phonelib.parse(address).e164
  end

  def self.find_by_address(address)
    self.find_by(address: canonicalize_address(address))
  end

  protected
  def canonicalize_address
    self.address = self.class.canonicalize_address(address)
  end

  def check_mobile_number
    return true if PhoneNumberUtils.valid_mobile_number?(address)
    errors.add(:address, 'must be valid mobile number')
  end
end
