require 'rails_helper'

RSpec.describe ParseConfigsController, type: :controller do
  describe "GET #index" do
    context "unauthenticated" do
      before do
        sign_out :user
        get :index
      end
      it { expect(response.status).to eq 302 }
    end

    context "authenticated" do
      before do
        sign_in create(:confirmed_user)
        get :index
      end
      it { expect(response.status).to eq 200 }
    end

  end
end
