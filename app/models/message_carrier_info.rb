class MessageCarrierInfo < ActiveRecord::Base
  belongs_to :carrier
  belongs_to :message
end
