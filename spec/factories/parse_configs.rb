FactoryGirl.define do
  factory :parse_config do
    kind "MyString"
    owner {create(:user)}
    name "MyString"
    message_defined_at_column false
    column_of_message "MyString"
    column_of_number "MyString"
    column_of_destination_reference "MyString"
    schedule_finish_time "MyString"
    schedule_start_time "MyString"
    timing_table "MyString"
    field_separator "MyString"
    headers_at_first_line false
    custom_message "MyText"
    skip_records 1
  end

end
