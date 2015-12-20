require 'rails_helper'

RSpec.describe "ftp_configurations/index", type: :view do
  before(:each) do
    assign(:ftp_configurations, [
      FtpConfiguration.create!(
        :owner => nil,
        :host => "Host",
        :port => "Port",
        :user => "User",
        :secret => "Secret",
        :passive => false,
        :kind => "Kind"
      ),
      FtpConfiguration.create!(
        :owner => nil,
        :host => "Host",
        :port => "Port",
        :user => "User",
        :secret => "Secret",
        :passive => false,
        :kind => "Kind"
      )
    ])
  end

  it "renders a list of ftp_configurations" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Host".to_s, :count => 2
    assert_select "tr>td", :text => "Port".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Secret".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Kind".to_s, :count => 2
  end
end
