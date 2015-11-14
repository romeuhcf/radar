require 'rails_helper'

def wait n
  sleep n
end

def given_i_have_pending_chats(owner, n = 5)
  n.times do
    destination = create(:destination)
    send_a_sms(destination , Faker::Lorem.sentence, owner)
    receive_an_answer(destination, Faker::Lorem.sentence)
  end
end

def send_a_sms(destination, content, owner)
  create(:message, :sent, destination: destination, content: content, owner: owner)
end

def receive_an_answer(destination, content)
  ChatRoomService.new.receive_message_from(destination.address, content, Time.now)
end

feature 'Display ansered messages as a chat', :js do
  let(:user){create(:confirmed_user)}
  let(:destination) { create(:destination) }

  scenario 'already existing' do
    send_a_sms(destination , "jose, vc deve", user)
    receive_an_answer(destination, "nao sou jose")
    sign_in user
    visit(authenticated_root_path)
    expect(page).to_not  have_content("No Pending Messages")
    expect(page).to have_content("jose, vc deve")
    expect(page).to have_content("nao sou jose")
  end

  scenario 'recently received' do
    send_a_sms(destination , "jose, vc deve", user)
    sign_in user
    visit(authenticated_root_path)
    expect(page).to have_content("No Pending Messages")
    receive_an_answer(destination, "nao sou jose")
    wait 5.seconds
    expect(page).to_not  have_content("No Pending Messages")
    expect(page).to have_content("jose, vc deve")
    expect(page).to have_content("nao sou jose")
  end

  scenario 'answering' do
    Sidekiq::Testing.fake!
    n_pending = 3
    given_i_have_pending_chats(user, n_pending)
    sign_in user
    visit(authenticated_root_path)

    expect(page).to_not  have_content("No Pending Messages")

    expect(all('.chat-room').size).to eq n_pending
    click_on 'Responder', match: :first
    within ".modal" do
      find("input").set "ok, man"
      find(".btn-primary").click
    end
    wait(5)
    expect(all('.chat-room').size).to eq n_pending - 1
  end

  scenario 'archiving' do
    n_pending = 3
    send_a_sms(destination , "jose, vc deve", user)
    receive_an_answer(destination, "nao sou jose")
    given_i_have_pending_chats(user, n_pending - 1 )

    sign_in user
    visit(authenticated_root_path)

    expect(page).to_not  have_content("No Pending Messages")

    expect(all('.chat-room').size).to eq n_pending
    click_on 'Arquivar', match: :first
    wait(3)
    expect(all('.chat-room').size).to eq n_pending - 1


    # unarchiving
    receive_an_answer(destination, "vao me remover?")
    wait(5)
    expect(all('.chat-room').size).to eq n_pending
  end
end

