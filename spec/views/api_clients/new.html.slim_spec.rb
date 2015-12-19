require 'rails_helper'

RSpec.describe "api_clients/new", type: :view do
  before(:each) do
    assign(:api_client, ApiClient.new(
      :owner => nil,
      :secret_key => "MyString",
      :enabled => false,
      :description => "MyString"
    ))
  end

  it "renders new api_client form" do
    render

    assert_select "form[action=?][method=?]", api_clients_path, "post" do

      assert_select "input#api_client_owner_id[name=?]", "api_client[owner_id]"

      assert_select "input#api_client_secret_key[name=?]", "api_client[secret_key]"

      assert_select "input#api_client_enabled[name=?]", "api_client[enabled]"

      assert_select "input#api_client_description[name=?]", "api_client[description]"
    end
  end
end
