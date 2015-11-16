require 'rails_helper'

feature 'admin route providers' do
  scenario 'not admin' do
    sign_in create(:confirmed_user)
    expect{
    visit rails_admin.new_path(model_name: 'route_provider')
    }.to raise_error(ActionController::RoutingError)
  end

  scenario 'admin' do
    user = create(:confirmed_user)
    user.add_role('admin')
    sign_in user.reload
    visit rails_admin.new_path(model_name: 'route_provider')
  end
end

