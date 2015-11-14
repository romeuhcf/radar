class ChatRoom < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :destination
  belongs_to :last_contacted_by, class_name: 'User'

  scope :with_destination, -> (destination) {     where(destination: destination) }
  scope :of_owner, -> (owner) {     where(owner: owner) }


  def messages
    Message.where(owner: self.owner, destination: self.destination)
  end

  def recent_messages(n = 2)
    messages.order('created_at desc').limit(2)
  end
end
