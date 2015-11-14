require 'rails_helper'

feature 'admin route provuders' do
  scenario 'listing' do
    sign_in create(:confirmed_user)
    visit rails_admin.new_path(model_name: 'route_provider')
  end
end

