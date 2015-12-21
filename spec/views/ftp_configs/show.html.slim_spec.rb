require 'rails_helper'

RSpec.describe "ftp_configs/show", type: :view do
  before(:each) do
    @ftp_config = assign(:ftp_config, create(:ftp_config))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Host/)
    expect(rendered).to match(/Port/)
    expect(rendered).to match(/User/)
    expect(rendered).to match(/Secret/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Kind/)
  end
end
