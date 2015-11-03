class MessageContent < ActiveRecord::Base
  belongs_to :message
end

#------------------------------------------------------------------------------
# MessageContent
#
# Name       SQL Type             Null    Default Primary
# ---------- -------------------- ------- ------- -------
# id         int(11)              false           true
# kind       varchar(255)         true            false
# message_id int(11)              true            false
# content    text                 true            false
# created_at datetime             false           false
# updated_at datetime             false           false
#
#------------------------------------------------------------------------------
