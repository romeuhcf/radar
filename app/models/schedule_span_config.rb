class ScheduleSpanConfig < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :start_span, class_name: 'NamedTimeSpan'
  belongs_to :finish_span, class_name: 'NamedTimeSpan'
  scope :named, ->{ where.not(name: nil) }


  def get_start_time
    relative? ? Time.zone.now + span : start_time
  end

  def get_finish_time
    relative? ? Time.zone.now + span : finish_time
  end
end
