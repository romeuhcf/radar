require 'rails_helper'
def json_response
  JSON.parse(response.body)
end

RSpec.describe ChatRoomsController, type: :controller do
  render_views
  describe "GET index" do
    context "unauthenticated" do
      before do
        sign_out :user
        get :index
      end
      it { expect(response.status).to eq 302 }
    end

    context "unauthenticated" do
      let!(:user) { create(:confirmed_user) }
      let(:destination) {create(:destination) }
      let!(:message) { create(:message, destination: destination, owner: user) }

      before do
        sign_in user
        create(:chat_room, owner: user, destination: destination, archived:false, answered: false, last_contacted_by: user)
        get :index, format: 'json'
      end

      it { expect(response.status).to eq 200 }
      it { expect(response.content_type).to eq 'application/json' }
      it { expect(json_response.count).to eq 1 }
      it { expect(json_response['chat_rooms'].first['destination']['address']).to eq destination.address }
    end
  end
end
