FactoryGirl.define do
  factory :schedule_span_config do
    owner nil
    name "MyString"
    relative false
    start_span nil
    finish_span nil
    start_time "2015-12-23 11:26:37"
    finish_time "2015-12-23 11:26:37"
    time_table "MyString"
    reschedule_when_time_table_ends false
  end

end
