require 'rails_helper'

feature 'admin route provuders' do
  scenario 'listing' do
    valid_user_sign_in
    visit rails_admin.new_path(model_name: 'route_provider')
  end
end

