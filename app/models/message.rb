#------------------------------------------------------------------------------
# Message
#
# Name                    SQL Type             Null    Default Primary
# ----------------------- -------------------- ------- ------- -------
# id                      int(11)              false           true   
# transmission_request_id int(11)              true            false  
# media                   varchar(255)         true            false  
# transmission_state      varchar(255)         true            false  
# reference_date          date                 true            false  
# weight                  int(11)              true    1       false  
# paid                    tinyint(1)           true    0       false  
# scheduled_to            datetime             true            false  
# sent_at                 datetime             true            false  
# billable                tinyint(1)           true            false  
# bill_id                 int(11)              true            false  
# created_at              datetime             false           false  
# updated_at              datetime             false           false  
# destination_id          int(11)              true            false  
#
#------------------------------------------------------------------------------
class Message < ActiveRecord::Base
  belongs_to :transmission_request, counter_cache: true
  belongs_to :destination
  has_one :message_carrier_info
  has_one :message_content

  scope :pending, -> { where(transmission_state: :processing) }

  include AASM

  aasm column: 'transmission_state' do
    state :processing, initial: true
    state :cancelled
    state :failed
    state :sent
  end

  def suspended?
    !transmission_request.processing? # may be moved to redis / memcache message board if this is heavy
  end
end

