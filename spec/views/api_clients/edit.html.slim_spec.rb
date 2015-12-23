require 'rails_helper'

RSpec.describe "api_clients/edit", type: :view do
  before(:each) do
    @api_client = assign(:api_client, ApiClient.create!(
      :owner => create(:user),
      :secret_key => "MyString",
      :enabled => false,
      :description => "MyString"
    ))
  end

  it "renders the edit api_client form" do
    render

    assert_select "form[action=?][method=?]", api_client_path(@api_client), "post" do
      assert_select "input#api_client_enabled[name=?]", "api_client[enabled]"
      assert_select "input#api_client_description[name=?]", "api_client[description]"
    end
  end
end
