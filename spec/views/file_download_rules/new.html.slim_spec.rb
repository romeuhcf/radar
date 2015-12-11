require 'rails_helper'

RSpec.describe "file_download_rules/new", type: :view do
  before(:each) do
    assign(:file_download_rule, FileDownloadRule.new(
      :description => "MyString",
      :enabled => false,
      :cron => "MyString",
      :server => "MyString",
      :port => 1,
      :user => "MyString",
      :pwd => "MyString",
      :passive => false,
      :remote_path => "MyString",
      :patterns => "MyString"
    ))
  end

  it "renders new file_download_rule form" do
    render

    assert_select "form[action=?][method=?]", file_download_rules_path, "post" do

      assert_select "input#file_download_rule_description[name=?]", "file_download_rule[description]"

      assert_select "input#file_download_rule_enabled[name=?]", "file_download_rule[enabled]"

      assert_select "input#file_download_rule_cron[name=?]", "file_download_rule[cron]"

      assert_select "input#file_download_rule_server[name=?]", "file_download_rule[server]"

      assert_select "input#file_download_rule_port[name=?]", "file_download_rule[port]"

      assert_select "input#file_download_rule_user[name=?]", "file_download_rule[user]"

      assert_select "input#file_download_rule_pwd[name=?]", "file_download_rule[pwd]"

      assert_select "input#file_download_rule_passive[name=?]", "file_download_rule[passive]"

      assert_select "input#file_download_rule_remote_path[name=?]", "file_download_rule[remote_path]"

      assert_select "input#file_download_rule_patterns[name=?]", "file_download_rule[patterns]"
    end
  end
end
