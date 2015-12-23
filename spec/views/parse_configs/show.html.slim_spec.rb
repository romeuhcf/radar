require 'rails_helper'

RSpec.describe "parse_configs/show", type: :view do
  before(:each) do
    @parse_config = assign(:parse_config,create(:parse_config))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Kind/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Column of message/)
    expect(rendered).to match(/Column of number/)
    expect(rendered).to match(/Column of destination reference/)
    expect(rendered).to match(/Schedule Finish Time/)
    expect(rendered).to match(/Schedule Start Time/)
    expect(rendered).to match(/Timing table/)
    expect(rendered).to match(/Field separator/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end
