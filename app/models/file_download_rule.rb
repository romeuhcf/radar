class FileDownloadRule < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  serialize :options, Hash
  validates :owner,   presence: true
  validates :name,    presence: true

  after_save :update_schedule
  after_destroy :unschedule

  def worker_label
    [self.owner.email, self.class.name, self.id, self.description].join('-').parameterize
  end

  protected
  def update_schedule
    unschedule!
    schedule!  if self.enabled?
  end

  def schedule!
    Sidekiq::Cron::Job.new(name: worker_label, cron: schedule, worker_class: worker_class)
  end

  def unschedule!
    Sidekiq::Cron::Job.destroy worker_label
  end
end
