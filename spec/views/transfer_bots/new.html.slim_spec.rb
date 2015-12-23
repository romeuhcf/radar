require 'rails_helper'

RSpec.describe "transfer_bots/new", type: :view do
  before(:each) do
    assign(:transfer_bot, TransferBot.new(
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

  xit "renders new transfer_bot form" do
    render

    assert_select "form[action=?][method=?]", transfer_bots_path, "post" do

      assert_select "input#transfer_bot_description[name=?]", "transfer_bot[description]"

      assert_select "input#transfer_bot_enabled[name=?]", "transfer_bot[enabled]"

      assert_select "input#transfer_bot_cron[name=?]", "transfer_bot[cron]"

      assert_select "input#transfer_bot_server[name=?]", "transfer_bot[server]"

      assert_select "input#transfer_bot_port[name=?]", "transfer_bot[port]"

      assert_select "input#transfer_bot_user[name=?]", "transfer_bot[user]"

      assert_select "input#transfer_bot_pwd[name=?]", "transfer_bot[pwd]"

      assert_select "input#transfer_bot_passive[name=?]", "transfer_bot[passive]"

      assert_select "input#transfer_bot_remote_path[name=?]", "transfer_bot[remote_path]"

      assert_select "input#transfer_bot_patterns[name=?]", "transfer_bot[patterns]"
    end
  end
end
