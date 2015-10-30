#------------------------------------------------------------------------------
# Message
#
# Name                 SQL Type             Null    Default Primary
# -------------------- -------------------- ------- ------- -------
# id                   int(11)              false           true
# user_id              int(11)              true            false
# media                varchar(255)         true            false
# transmission_state   varchar(255)         true            false
# reference_date       date                 true            false
# weight               int(11)              true            false
# billable             tinyint(1)           true            false
# scheduled_to         datetime             true            false
# sent_at              datetime             true            false
# message_request_id   int(11)              true            false
# created_at           datetime             false           false
# updated_at           datetime             false           false
#
#------------------------------------------------------------------------------
class Message < ActiveRecord::Base
  belongs_to :customer, polymorphic: true
  belongs_to :transmission_request, counter_cache: true
  belongs_to :destination
  has_one :message_carrier_info
  has_one :message_content
end

