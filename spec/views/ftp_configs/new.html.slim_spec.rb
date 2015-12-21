require 'rails_helper'

RSpec.describe "ftp_configs/new", type: :view do
  before(:each) do
    assign(:ftp_config, FtpConfig.new(
      :owner => nil,
      :host => "MyString",
      :port => "MyString",
      :user => "MyString",
      :secret => "MyString",
      :passive => false,
      :kind => "MyString"
    ))
  end

  it "renders new ftp_config form" do
    render

    assert_select "form[action=?][method=?]", ftp_configs_path, "post" do

      assert_select "input#ftp_config_host[name=?]", "ftp_config[host]"

      assert_select "input#ftp_config_port[name=?]", "ftp_config[port]"

      assert_select "input#ftp_config_user[name=?]", "ftp_config[user]"

      assert_select "input#ftp_config_secret[name=?]", "ftp_config[secret]"

      assert_select "input#ftp_config_passive[name=?]", "ftp_config[passive]"

      assert_select "input#ftp_config_kind[name=?]", "ftp_config[kind]"
    end
  end
end
