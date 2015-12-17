require 'rails_helper'

RSpec.describe "api_clients/index", type: :view do
  before(:each) do
    assign(:api_clients, [
      ApiClient.create!(
        :owner => nil,
        :secret_key => "Secret Key",
        :enabled => false,
        :description => "Description"
      ),
      ApiClient.create!(
        :owner => nil,
        :secret_key => "Secret Key",
        :enabled => false,
        :description => "Description"
      )
    ])
  end

  it "renders a list of api_clients" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Secret Key".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
