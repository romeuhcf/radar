require 'rails_helper'

RSpec.describe "ftp_configs/index", type: :view do
  before(:each) do
    assign(:ftp_configs, [
      create(:ftp_config),
      create(:ftp_config),
    ])
  end

  it "renders a list of ftp_configs" do
    render
  end
end
