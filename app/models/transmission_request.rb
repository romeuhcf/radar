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
  serialize :options, Hash
  include AASM

  aasm column: "status" do
    state :draft, initial: true
    state :processing
    state :paused
    state :cancelled
    state :failed
    state :finished

    event :resume do
      transitions from: :paused, to: :processing
    end
  end

  def pending_messages
    messages.pending
  end

  def csv_column_count
    10 # TODO real calculate column count when csv
  end
end
