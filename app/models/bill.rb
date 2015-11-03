class Bill < ActiveRecord::Base
  belongs_to :customer, polymorphic: true
  has_many :messages
end

#------------------------------------------------------------------------------
# Bill
#
# Name                 SQL Type             Null    Default Primary
# -------------------- -------------------- ------- ------- -------
# id                   int(11)              false           true   
# customer_id          int(11)              true            false  
# customer_type        varchar(255)         true            false  
# reference_date_begin date                 true            false  
# reference_date_end   date                 true            false  
# grand_total          decimal(10,0)        true            false  
# paid                 tinyint(1)           true            false  
# due_to               date                 true            false  
# created_at           datetime             false           false  
# updated_at           datetime             false           false  
#
#------------------------------------------------------------------------------
