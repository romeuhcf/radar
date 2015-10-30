class Bill < ActiveRecord::Base
  belongs_to :customer, polymorphic: true
  has_many :messages
end
