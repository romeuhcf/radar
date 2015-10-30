class Carrier < ActiveRecord::Base
  serialize :configuration
  validates :name, presence: true
  validates :implementation_class, presence: true
  has_many :message_carrier_infos
end
