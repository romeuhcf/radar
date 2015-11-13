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
  has_one :localizer, as: :item, dependent: :destroy
  has_one :message_content, dependent: :destroy
  has_many :status_notifications, dependent: :destroy

  validates :scheduled_to, presence: true

  scope :pending, -> { where(transmission_state: :processing) }
  # after_create :enqueue_transmission

  #validates :transmission_request, presence: true
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

  def set_transmission_result(result, route_provider_or_id)
    route_provider_id = route_provider_or_id.is_a?(RouteProvider) ? route_provider_or_id.id : route_provider_or_id

    self.status_notifications.create!(route_provider_id: route_provider_id, provider_status: result.raw)

    if result.success?
      self.create_localizer(uid: result.uid)
      self.transmission_state = 'sent'
      self.billable = true
    else
      self.transmission_state = 'failed'
    end

    self.save!
  end

  def update_transmission_result(the_status)
    self.billable = the_status.billable?
    self.transmission_state = the_status.success? ? 'sent' : 'failed'
    self.status_notifications.create!(provider_status: the_status.raw)
    self.save!
  end

  # TODO check valid number
  def check_message_duplication
    # TODO check duplicate message
    # generate hash with message / number
    # check or set at cache
  end
end
