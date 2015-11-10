class SmsCallbackWorker
  include Sidekiq::Worker
  sidekiq_options :queue => 'sms-callbacks', :retry => true, :backtrace => true

  def perform(params)
fail params
  end
end
