require 'rails_helper'

RSpec.describe TransmissionRequestsController, type: :controller do
  describe "unauthenticated" do
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "authenticated" do
    let!(:user) { create(:confirmed_user) }
    before do
      sign_in user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #show" do
      let!(:transmission_request) { create(:transmission_request, owner: user)}
      it "returns http success" do
        get :show, id: transmission_request.id
        expect(response).to have_http_status(200)
      end
    end
  end


end
