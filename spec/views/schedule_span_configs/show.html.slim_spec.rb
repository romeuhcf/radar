require 'rails_helper'

RSpec.describe "schedule_span_configs/show", type: :view do
  before(:each) do
    @schedule_span_config = assign(:schedule_span_config, ScheduleSpanConfig.create!(
      :owner => nil,
      :name => "Name",
      :relative => false,
      :start_span => nil,
      :finish_span => nil,
      :time_table => "Time Table",
      :reschedule_when_time_table_ends => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Time Table/)
    expect(rendered).to match(/false/)
  end
end
