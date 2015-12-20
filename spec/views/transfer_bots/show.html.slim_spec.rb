require 'rails_helper'

RSpec.describe "transfer_bots/show", type: :view do
  before(:each) do
    @transfer_bot = assign(:transfer_bot, TransferBot.create!(
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
    ))
  end

  xit "renders attributes in <p>" do
    render
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Cron/)
    expect(rendered).to match(/Server/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/User/)
    expect(rendered).to match(/Pwd/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Remote Path/)
    expect(rendered).to match(/Patterns/)
  end
end
