class TransferBot < ActiveRecord::Base
  has_paper_trail ignore: [:last_success_at, :updated_at]

  belongs_to :owner, polymorphic: true
  has_many self.versions_association_name, :as => :item, :foreign_key => :item_id, :class_name => version_class_name
  belongs_to :ftp_config
  accepts_nested_attributes_for :ftp_config

  validates :owner,   presence: true
  validates :description,    presence: true, format: /.{3,}/
  validates :worker_class,    presence: true
  validates :schedule,    presence: true

  validates :remote_path, presence: true
  validates :patterns, presence: true

  validate :validate_worker_class
  validate :validate_schedule
  validate :test_connection

  after_save :update_schedule
  after_destroy :unschedule!

  def worker_label
    ['owner', owner.class.name, owner.id, self.class.name, self.id].join('-').parameterize
  end

  def activate!
    self.enabled = true
    self.save!
  end

  def deactivate!
    self.enabled = false
    self.save!
  end

  protected
  def update_schedule
    unschedule!
    schedule! if self.enabled?
  end

  def schedule!
    Rails.logger.info "Adicionando schedule #{worker_label} #{schedule}"
    job = Sidekiq::Cron::Job.new(name: worker_label, cron: schedule, class: worker_class, args: [self.id])
    if job.valid?
      job.save
    else
      fail "invalid job #{job.errors}"
    end
  end

  def unschedule!
    Rails.logger.info "Removendo schedule #{worker_label}"
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
    return true if !enabled?
    FileDownloadWorker.new.test_connection(self)
  rescue
    errors.add(:ftp_config, $!.class.name)
  end
end
