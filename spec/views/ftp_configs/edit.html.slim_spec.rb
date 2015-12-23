require 'rails_helper'

RSpec.describe "ftp_configs/edit", type: :view do
  before(:each) do
    @ftp_config = assign(:ftp_config, create(:ftp_config))
  end

  it "renders the edit ftp_config form" do
    render

    assert_select "form[action=?][method=?]", ftp_config_path(@ftp_config), "post" do

      assert_select "input#ftp_config_host[name=?]", "ftp_config[host]"

      assert_select "input#ftp_config_port[name=?]", "ftp_config[port]"

      assert_select "input#ftp_config_user[name=?]", "ftp_config[user]"

      assert_select "input#ftp_config_secret[name=?]", "ftp_config[secret]"

      assert_select "input#ftp_config_passive[name=?]", "ftp_config[passive]"
    end
  end
end
