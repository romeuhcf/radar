#------------------------------------------------------------------------------
# TransmissionRequest
#
# Name                             SQL Type             Null    Default Primary
# -------------------------------- -------------------- ------- ------- -------
# id                               int(11)              false           true
# user_id                          int(11)              true            false
# requested_via                    varchar(255)         true            false
# status                           varchar(255)         true            false
# reference_date                   date                 true            false
# messages_count                   int(11)              true            false
# estimated_request_bytes_total    int(11)              true            false
# estimated_request_bytes_progress int(11)              true            false
# transmissions_done               int(11)              true            false
# success_rate                     float                true            false
# created_at                       datetime             false           false
# updated_at                       datetime             false           false
#
#------------------------------------------------------------------------------
class TransmissionRequest < ActiveRecord::Base
  belongs_to :user
  has_many :messages
end

