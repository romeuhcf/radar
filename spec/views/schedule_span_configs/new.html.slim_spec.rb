require 'rails_helper'

RSpec.describe "schedule_span_configs/new", type: :view do
  before(:each) do
    assign(:schedule_span_config, ScheduleSpanConfig.new(
      :owner => nil,
      :name => "MyString",
      :relative => false,
      :start_span => nil,
      :finish_span => nil,
      :time_table => "MyString",
      :reschedule_when_time_table_ends => false
    ))
  end

  it "renders new schedule_span_config form" do
    render

    assert_select "form[action=?][method=?]", schedule_span_configs_path, "post" do

      assert_select "input#schedule_span_config_name[name=?]", "schedule_span_config[name]"

      assert_select "input#schedule_span_config_relative[name=?]", "schedule_span_config[relative]"

      assert_select "select#schedule_span_config_start_span_id[name=?]", "schedule_span_config[start_span_id]"

      assert_select "select#schedule_span_config_finish_span_id[name=?]", "schedule_span_config[finish_span_id]"

      assert_select "select#schedule_span_config_time_table[name=?]", "schedule_span_config[time_table]"

    end
  end
end
