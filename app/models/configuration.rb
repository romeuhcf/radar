#------------------------------------------------------------------------------
# Configuration
#
# Name        SQL Type             Null    Default Primary
# ----------- -------------------- ------- ------- -------
# id          int(11)              false           true
# key         varchar(255)         true            false
# description varchar(255)         true            false
# default     varchar(255)         true            false
# value       varchar(255)         true            false
# created_at  datetime             false           false
# updated_at  datetime             false           false
#
#------------------------------------------------------------------------------
class Configuration < ActiveRecord::Base
  serialize :value

  def self.get(key, default_value = nil, default_description = nil)
    stored = where(key: key).first
    unless stored
      stored = create!(key: key, value: default_value, description: default_description || key)
    end
    stored.value
  end
end
