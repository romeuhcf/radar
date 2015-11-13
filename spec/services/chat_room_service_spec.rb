require 'rails_helper'

def send_message_to(destination, owner)
  create(:message, destination: destination, owner: owner )
end


describe ChatRoomService do
  let(:destination){ create(:destination) }
  let(:user){ create(:user) }
  it "creates as chatroom when a mobile originated message is received" do
    # Given
    send_message_to(destination, user)

    # When
    subject.receive_message_from(destination.address, Faker::Lorem.sentence, Time.now)

    # Then
    expect(ChatRoom.count).to eq 1
    expect(destination.chat_rooms.count).to eq 1
    the_chat = destination.chat_rooms.last
    expect(the_chat).to_not be_archived
    expect(the_chat.destination).to eq destination
    expect(the_chat).to_not be_answered

    # Later
    # When
    expect {
      Sidekiq::Testing.fake! do
        subject.reply_to_destination(the_chat, user, "a message text")
      end
    }.to change{Message.count}.by(1)

    the_chat.reload
    expect(the_chat).to_not be_archived
    expect(the_chat).to be_answered
    expect(the_chat.last_contacted_by).to eq user

    # Later
    # When
    subject.receive_message_from(destination.address, Faker::Lorem.sentence, Time.now)
    the_chat.reload
    expect(the_chat).to_not be_archived
    expect(the_chat).to_not be_answered
    expect(the_chat.last_contacted_by).to eq user
  end

  it "reopens chat when mobile originate message is received"
  it "can be mark as closed"
end
