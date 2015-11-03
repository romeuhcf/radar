class Carrier < ActiveRecord::Base
  serialize :configuration
  validates :name, presence: true
  validates :implementation_class, presence: true
  has_many :message_carrier_infos
end

#------------------------------------------------------------------------------
# Carrier
#
# Name                 SQL Type             Null    Default Primary
# -------------------- -------------------- ------- ------- -------
# id                   int(11)              false           true
# media                varchar(255)         true            false
# name                 varchar(255)         true            false
# active               tinyint(1)           true    0       false
# implementation_class varchar(255)         true            false
# configuration        text                 true            false
# created_at           datetime             false           false
# updated_at           datetime             false           false
#
#------------------------------------------------------------------------------
