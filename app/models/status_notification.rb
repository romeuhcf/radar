class StatusNotification < ActiveRecord::Base
  belongs_to :route_provider
  belongs_to :message
end

#------------------------------------------------------------------------------
# StatusNotification
#
# Name              SQL Type             Null    Default Primary
# ----------------- -------------------- ------- ------- -------
# id                int(11)              false           true   
# route_provider_id int(11)              true            false  
# message_id        int(11)              true            false  
# provider_status   varchar(255)         true            false  
# created_at        datetime             false           false  
# updated_at        datetime             false           false  
#
#------------------------------------------------------------------------------
