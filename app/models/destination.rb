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
class Destination < ActiveRecord::Base
  has_many :messages
  has_many :chat_rooms

  # TODO before_validate --- make msisdn
  #
  def last_outgoing_sent_message
    messages.where(transmission_state: 'sent').order('sent_at DESC').first
  end

  def self.canonicalize_address(address)
    address # TODO make sure it is in msisdn format
  end
end
