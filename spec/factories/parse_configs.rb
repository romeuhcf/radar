FactoryGirl.define do
  factory :parse_config do
    kind "csv"
    owner {create(:user)}
    name "MyString"
    message_defined_at_column false
    column_of_message "B"
    column_of_number "A"
    column_of_destination_reference "MyString"
    field_separator ";"
    headers_at_first_line false
    custom_message "MyText"
    skip_records 1
  end

end
