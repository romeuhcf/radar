class Division < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
end

#------------------------------------------------------------------------------
# Division
#
# Name       SQL Type             Null    Default Primary
# ---------- -------------------- ------- ------- -------
# id         int(11)              false           true
# owner_id   int(11)              true            false
# owner_type varchar(255)         true            false
# name       varchar(255)         true            false
# created_at datetime             false           false
# updated_at datetime             false           false
#
#------------------------------------------------------------------------------
