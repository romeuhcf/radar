class ApiClient < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  before_validation :create_hash
  validates :secret_key, presence: true
  validates :owner, presence: true

  def create_hash
    if secret_key.blank?
      self.secret_key = SecureRandom.hex(16)
    end
  end
end
