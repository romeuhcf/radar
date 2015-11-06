class Localizer < ActiveRecord::Base
  belongs_to :item, polymorphic: true
  validates :uid, uniqueness: true
  validates :item, presence: true

  def self.get_item(hash, type = nil)
    scope = type ? where(item_type: type) : self
    loc = scope.find_by(uid: hash)
    loc && loc.item
  end
end
