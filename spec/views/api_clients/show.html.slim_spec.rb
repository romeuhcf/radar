require 'rails_helper'

RSpec.describe "api_clients/show", type: :view do
  before(:each) do
    @api_client = assign(:api_client, ApiClient.create!(
      :owner => create(:user),
      :secret_key => "Secret Key",
      :enabled => false,
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Secret Key/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Description/)
  end
end
