require 'rails_helper'

RSpec.describe "ftp_configurations/show", type: :view do
  before(:each) do
    @ftp_configuration = assign(:ftp_configuration, FtpConfiguration.create!(
      :owner => nil,
      :host => "Host",
      :port => "Port",
      :user => "User",
      :secret => "Secret",
      :passive => false,
      :kind => "Kind"
    ))
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
