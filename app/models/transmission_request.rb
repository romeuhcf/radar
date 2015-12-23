#------------------------------------------------------------------------------
# TransmissionRequest
#
# Name           SQL Type             Null    Default Primary
# -------------- -------------------- ------- ------- -------
# id             int(11)              false           true
# owner_id       int(11)              true            false
# owner_type     varchar(255)         true            false
# user_id        int(11)              true            false
# identification varchar(255)         true            false
# requested_via  varchar(255)         true            false
# status         varchar(255)         true            false
# reference_date date                 true            false
# messages_count int(11)              true            false
# created_at     datetime             false           false
# updated_at     datetime             false           false
# division_id    int(11)              true            false
#
#------------------------------------------------------------------------------
class TransmissionRequest < ActiveRecord::Base

  belongs_to :user
  belongs_to :owner, polymorphic: true
  has_many :messages
  mount_uploader :batch_file, BatchFileUploader
  validates :owner, presence: true
  include AASM

  belongs_to :parse_config
  accepts_nested_attributes_for :parse_config
  belongs_to :schedule_span_config
  accepts_nested_attributes_for :schedule_span_config

  before_save :set_configs_ownership

  validates :parse_config, presence: true, unless: ->(me){ me.status.to_s == 'draft' or me.identification == 'inline' }
  validates :schedule_span_config, presence: true, unless: ->(me){ me.status.to_s == 'draft' or me.identification == 'inline'}

  aasm column: "status" do
    state :draft, initial: true
    state :scheduled
    state :processing
    state :paused
    state :cancelled
    state :failed
    state :finished

    event :resume do
      transitions from: :paused, to: :processing
    end
    event :cancel do
      transitions from: :processing, to: :cancelled
    end
    event :pause do
      transitions from: :processing, to: :paused
    end
  end

  def batch_file_type
    batch_file.current_path && File.extname(batch_file.current_path).gsub(/^\./, '').downcase
  end

  def pending_messages
    messages.pending
  end

  def composer
    @composer ||= TransmissionRequestCompositionService.new(self)
  end

  def set_configs_ownership
    if parse_config
      parse_config.owner = self.owner
      parse_config.save!
    end
    if schedule_span_config
      schedule_span_config.owner = self.owner
      schedule_span_config.save!
    end
  end

  require 'extensions/file'
  def batch_file_from_file(file_path, the_original_filename)
    io = File.open(file_path)
    io.force_name the_original_filename
    self.batch_file = io
  end
end
