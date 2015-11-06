require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #index" do
    context "unauthenticated" do
      before do
        sign_in nil
        get :index
      end
      it { expect(response.status).to eq 302 }
    end

    context "unauthenticated" do
      before do
        sign_in
        get :index
      end
      it { expect(response.status).to eq 200 }
    end

  end

end
