FactoryGirl.define do
  factory :message do
    media "MyString"
    weight ""
    transmission_state "processing"
    billable false
    scheduled_to "2015-10-30 03:54:17"
    sent_at "2015-10-30 03:54:17"
    transmission_request nil
  end

end
