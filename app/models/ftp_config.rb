class FtpConfig < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  #validates :owner, presence: true
  validates :host, presence: true
  validates :port, presence: true
  validates :user, presence: true
  validates :secret, presence: true
end
