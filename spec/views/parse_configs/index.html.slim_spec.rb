require 'rails_helper'

RSpec.describe "parse_configs/index", type: :view do
  before(:each) do
    assign(:parse_configs, [
      ParseConfig.create!(
        :kind => "Kind",
        :owner => create(:user),
        :name => "Name",
        :message_defined_at_column => true,
        :column_of_message => "Column Of Message",
        :column_of_number => "Column Of Number",
        :column_of_destination_reference => "Column Of Destination Reference",
        :field_separator => "Field Separator",
        :headers_at_first_line => false,
        :custom_message => "MyText",
        :skip_records => 1
      ),
      ParseConfig.create!(
        :kind => "Kind",
        :owner => create(:user),
        :name => "Name",
        :message_defined_at_column => true,
        :column_of_message => "Column Of Message",
        :column_of_number => "Column Of Number",
        :column_of_destination_reference => "Column Of Destination Reference",
        :field_separator => "Field Separator",
        :headers_at_first_line => false,
        :custom_message => "MyText",
        :skip_records => 1
      )
    ])
  end

  it "renders a list of parse_configs" do
    render
    assert_select "tr>td", :text => "Kind".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
