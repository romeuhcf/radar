require 'rails_helper'

RSpec.describe "ftp_configurations/edit", type: :view do
  before(:each) do
    @ftp_configuration = assign(:ftp_configuration, FtpConfiguration.create!(
      :owner => nil,
      :host => "MyString",
      :port => "MyString",
      :user => "MyString",
      :secret => "MyString",
      :passive => false,
      :kind => "MyString"
    ))
  end

  it "renders the edit ftp_configuration form" do
    render

    assert_select "form[action=?][method=?]", ftp_configuration_path(@ftp_configuration), "post" do

      assert_select "input#ftp_configuration_owner_id[name=?]", "ftp_configuration[owner_id]"

      assert_select "input#ftp_configuration_host[name=?]", "ftp_configuration[host]"

      assert_select "input#ftp_configuration_port[name=?]", "ftp_configuration[port]"

      assert_select "input#ftp_configuration_user[name=?]", "ftp_configuration[user]"

      assert_select "input#ftp_configuration_secret[name=?]", "ftp_configuration[secret]"

      assert_select "input#ftp_configuration_passive[name=?]", "ftp_configuration[passive]"

      assert_select "input#ftp_configuration_kind[name=?]", "ftp_configuration[kind]"
    end
  end
end
