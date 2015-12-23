require 'rails_helper'

RSpec.describe "schedule_span_configs/index", type: :view do
  before(:each) do
    assign(:schedule_span_configs, [
      ScheduleSpanConfig.create!(
        :owner => nil,
        :name => "Name",
        :relative => false,
        :start_span => nil,
        :finish_span => nil,
        :time_table => "Time Table",
        :reschedule_when_time_table_ends => false
      ),
      ScheduleSpanConfig.create!(
        :owner => nil,
        :name => "Name",
        :relative => false,
        :start_span => nil,
        :finish_span => nil,
        :time_table => "Time Table",
        :reschedule_when_time_table_ends => false
      )
    ])
  end

  it "renders a list of schedule_span_configs" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
