#------------------------------------------------------------------------------
# MessageCarrierInfo
#
# Name           SQL Type             Null    Default Primary
# -------------- -------------------- ------- ------- -------
# id             int(11)              false           true
# carrier_id     int(11)              true            false
# carrier_hash   varchar(255)         true            false
# carrier_status varchar(255)         true            false
# message_id     int(11)              true            false
# created_at     datetime             false           false
# updated_at     datetime             false           false
#
#------------------------------------------------------------------------------
class MessageCarrierInfo < ActiveRecord::Base
  belongs_to :carrier
  belongs_to :message
end
