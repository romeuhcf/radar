#------------------------------------------------------------------------------
# Message
#
# Name                    SQL Type             Null    Default Primary
# ----------------------- -------------------- ------- ------- -------
# id                      int(11)              false           true
# transmission_request_id int(11)              true            false
# media                   varchar(255)         true            false
# transmission_state      varchar(255)         true            false
# reference_date          date                 true            false
# weight                  int(11)              true    1       false
# paid                    tinyint(1)           true    0       false
# scheduled_to            datetime             true            false
# sent_at                 datetime             true            false
# billable                tinyint(1)           true            false
# bill_id                 int(11)              true            false
# created_at              datetime             false           false
# updated_at              datetime             false           false
# destination_id          int(11)              true            false
#
#------------------------------------------------------------------------------
class Message < ActiveRecord::Base
  belongs_to :transmission_request, counter_cache: true
  belongs_to :destination
  has_one :localizer, as: :item
  has_one :message_content
  has_many :status_notifications
  validates :scheduled_to, presence: true

  scope :pending, -> { where(transmission_state: :processing) }
  after_create :enqueue_transmission

  before_validation :check_message_duplication

  include AASM

  aasm column: "transmission_state" do
    state :processing, initial: true
    state :cancelled
    state :failed
    state :sent
  end

  def self.find_by_localizer(hash)
    ::Localizer.get_item(hash, self.name)
  end

  def suspended?
    !transmission_request.processing? # may be moved to redis / memcache message board if this is heavy
  end

  def enqueue_transmission
    MessageRouterWorker.perform_at(self.scheduled_to + rand(10) , self.id)
  end

  def body
    message_content.content
  end

  def set_transmission_result(result, route_provider)
    self.status_notifications.create!(route_provider_id: route_provider.id, provider_status: result.raw)
    self.create_localizer(uid: result.uid)
    self.transmission_state = result.success? ? 'sent' : 'fail'
    self.save!
  end

  # TODO check valid number
  def check_message_duplication
    # TODO check duplicate message
    # generate hash with message / number
    # check or set at cache
  end
end
