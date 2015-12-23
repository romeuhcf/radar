FactoryGirl.define do
  factory :transfer_bot do
    owner { create(:user) }
    enabled false
    description "MyString"
    schedule '* * * * *'
    status 'success'
    remote_path '.'
    patterns '*.csv'
    ftp_config { create(:ftp_config) }
    parse_config { create(:parse_config) }
    schedule_span_config { create(:schedule_span_config) }
    worker_class 'FileDownloadWorker'
  end

end
