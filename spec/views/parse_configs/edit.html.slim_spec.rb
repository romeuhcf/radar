require 'rails_helper'

RSpec.describe "parse_configs/edit", type: :view do
  before(:each) do
    @parse_config = assign(:parse_config, create(:parse_config))
  end

  it "renders the edit parse_config form" do
    render

    assert_select "form[action=?][method=?]", parse_config_path(@parse_config), "post" do

      assert_select "input#parse_config_kind[name=?]", "parse_config[kind]"

      assert_select "input#parse_config_name[name=?]", "parse_config[name]"

      assert_select "input#parse_config_message_defined_at_column[name=?]", "parse_config[message_defined_at_column]"

      assert_select "input#parse_config_column_of_message[name=?]", "parse_config[column_of_message]"

      assert_select "input#parse_config_column_of_number[name=?]", "parse_config[column_of_number]"

      assert_select "input#parse_config_column_of_destination_reference[name=?]", "parse_config[column_of_destination_reference]"

      assert_select "input#parse_config_schedule_finish_time[name=?]", "parse_config[schedule_finish_time]"

      assert_select "input#parse_config_schedule_start_time[name=?]", "parse_config[schedule_start_time]"

      assert_select "input#parse_config_timing_table[name=?]", "parse_config[timing_table]"

      assert_select "input#parse_config_field_separator[name=?]", "parse_config[field_separator]"

      assert_select "input#parse_config_headers_at_first_line[name=?]", "parse_config[headers_at_first_line]"

      assert_select "textarea#parse_config_custom_message[name=?]", "parse_config[custom_message]"

      assert_select "input#parse_config_skip_records[name=?]", "parse_config[skip_records]"
    end
  end
end
