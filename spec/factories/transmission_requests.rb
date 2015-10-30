FactoryGirl.define do
  factory :transmission_request do
    user nil
requested_via "MyString"
status "MyString"
reference_date "2015-10-30"
messages_count 1
estimated_request_bytes_total 1
estimated_request_bytes_progress 1
transmissions_done 1
success_rate 1.5
  end

end
