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

#------------------------------------------------------------------------------
# Localizer
#
# Name       SQL Type             Null    Default Primary
# ---------- -------------------- ------- ------- -------
# id         int(11)              false           true   
# item_id    int(11)              true            false  
# item_type  varchar(255)         true            false  
# uid        varchar(255)         true            false  
# created_at datetime             false           false  
# updated_at datetime             false           false  
#
#------------------------------------------------------------------------------
