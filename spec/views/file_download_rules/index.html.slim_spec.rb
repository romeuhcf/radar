require 'rails_helper'

RSpec.describe "file_download_rules/index", type: :view do
  before(:each) do
    assign(:file_download_rules, [
      FileDownloadRule.create!(
        :description => "Description",
        :enabled => false,
        :cron => "Cron",
        :server => "Server",
        :port => 1,
        :user => "User",
        :pwd => "Pwd",
        :passive => false,
        :remote_path => "Remote Path",
        :patterns => "Patterns"
      ),
      FileDownloadRule.create!(
        :description => "Description",
        :enabled => false,
        :cron => "Cron",
        :server => "Server",
        :port => 1,
        :user => "User",
        :pwd => "Pwd",
        :passive => false,
        :remote_path => "Remote Path",
        :patterns => "Patterns"
      )
    ])
  end

  it "renders a list of file_download_rules" do
    render
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Cron".to_s, :count => 2
    assert_select "tr>td", :text => "Server".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Pwd".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Remote Path".to_s, :count => 2
    assert_select "tr>td", :text => "Patterns".to_s, :count => 2
  end
end
