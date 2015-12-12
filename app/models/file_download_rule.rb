class FileDownloadRule < ActiveRecord::Base
  has_paper_trail
  belongs_to :owner, polymorphic: true

  serialize :process_options, Hash
  serialize :transfer_options, Hash
  validates :owner,   presence: true
  validates :description,    presence: true
  validates :worker_class,    presence: true
  validates :schedule,    presence: true
  validate :validate_worker_class
  validate :validate_schedule
  validate :test_connection
  after_save :update_schedule
  after_destroy :unschedule!

  def worker_label
    [self.owner.email, self.class.name, self.id, self.description].join('-').parameterize
  end

  def transfer_options
    OpenStruct.new(read_attribute(:transfer_options))
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

  def validate_worker_class
    begin
      klass = worker_class.constantize
      errors.add(:worker_class, "doesn't respond to #perform") unless klass.instance_methods(false).include?(:perform)
      errors.add(:worker_class, "doesn't respond to #test_connection") unless klass.instance_methods(false).include?(:test_connection)
    rescue NameError
      errors.add(:worker_class, 'not found')
    end
  end

  def validate_schedule
    Rufus::Scheduler.parse(schedule)
  rescue ArgumentError
    errors.add(:schedule, 'invalid format')
  end

  def test_connection
    klass = worker_class.constantize
    instance = klass.new
    instance.test_connection(self)
  rescue
    errors.add(:transfer_options, $!.class.name)
  end
end
