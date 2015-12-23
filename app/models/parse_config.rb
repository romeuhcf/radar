class ParseConfig < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  #validates :owner, presence: true

  #TODO implement this in relative mode
  def schedule_start_time
    read_attribute(:schedule_start_time) &&  Time.zone.parse(read_attribute(:schedule_start_time))
  end

  def schedule_finish_time
    read_attribute(:schedule_finish_time) &&   Time.zone.parse(read_attribute(:schedule_finish_time))
  end
end
