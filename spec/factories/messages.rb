FactoryGirl.define do
  factory :message do
    media "MyString"
    user nil
    weight ""
    transmission_state "MyString"
    billable false
    scheduled_to "2015-10-30 03:54:17"
    sent_at "2015-10-30 03:54:17"
    message_request nil
  end

end
