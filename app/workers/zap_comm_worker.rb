class ZapCommWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :zap_comm, :retry => true, :backtrace => true

  def perform(zap_line_id)
    zl = ZapLine.find(zap_line_id)
    system("#{Rails.root}/bin/zaporama/cli -C #{zl.country_code} -p #{zl.phone} -P #{zl.auth_key}")
  end

  def self.communicate_with(phone)
    queue = "zap_comm_#{phone}"
    Sidekiq::Queue[queue].limit = 1
    Sidekiq::Client.push({
      'class' => self,
      'queue' => queue,
      'args'  => [ phone ]
    })
  end
end

