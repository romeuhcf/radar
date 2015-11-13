class ChatRoomService
  def receive_message_from(incoming_message)
    in_reply_to = incoming_message.destination.last_outgoing_message
    fail "Received message have no precedent transmission" unless  in_reply_to
    fail "Null in reply to message owner " unless in_reply_to.owner
    incoming_message.owner = in_reply_to.owner
    incoming_message.save!
    create_or_update_chat_room(incoming_message)
  end

  def create_or_update_chat_room(incoming_message)
    fail "null owner of incoming message" unless incoming_message.owner
    fail "null destination of incoming message" unless incoming_message.destination
    chat = ChatRoom.with_destination(incoming_message.destination).of_owner(incoming_message.owner).first ||
      ChatRoom.create!(destination: incoming_message.destination, owner: incoming_message.owner)


    chat.tap do |me|
      me.answered = false
      me.archived = false
    end.save!

  end

  def reply_to_destination(chat, user, message)
    transmission_request = transmission_request_for_chat(chat, user)

    chat.tap do |me|
      me.answered = true
      me.last_contacted_by = user
    end.save!

    Transmissions::SendBatchService.new.send_a_message(transmission_request.id, message, chat.destination, chat.owner)
  end

  def transmission_request_for_chat(chat, user)
    TransmissionRequest.create!(user: user, owner: chat.owner, identification: 'chat_response')
  end
end
