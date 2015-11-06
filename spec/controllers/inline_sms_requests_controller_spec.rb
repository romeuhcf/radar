require 'rails_helper'

RSpec.describe InlineSmsRequestsController, type: :controller do
  describe "GET new" do

    context "unauthenticated" do
      before do
        sign_in nil
        get :new
      end
      it { expect(response.status).to eq 302 }
    end

    context "unauthenticated" do
      before do
        sign_in
        get :new
      end
      it { expect(response.status).to eq 200 }
    end
  end
end
