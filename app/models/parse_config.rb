class ParseConfig < ActiveRecord::Base
  has_many :transfer_bot
  has_many :transmission_requests
  belongs_to :owner, polymorphic: true
  scope :named, ->{ where.not(name: nil) }
  #validates :owner, presence: true
end
