class ChatRoomService

  def receive_mobile_originated_message(mobile_originated_message)
    mo = mobile_originated_message
    receive_message_from(mo.address, mo.content, mo.sent_time)
  end

  def receive_message_from(address, content, sent_time)
    destination = Destination.find_by_address(address)

    unless destination
      Rails.logger.warn "Unknown sender of MO message from: #{address}"
      return nil
    end

    in_reply_to = destination.last_outgoing_sent_message

    unless in_reply_to
      Rails.logger.warn "Received message have no precedent transmission from #{address}"
      return nil
    end

    unless in_reply_to.owner
      Rails.logger.warn  "Null in reply to message owner from #{address}, #{in_reply_to.owner_id}"
      return nil
    end

    incoming_message = create_answer_message(content, destination, in_reply_to.owner, sent_time)
    create_or_update_chat_room(incoming_message)
  end

  def reply_to_destination(chat, user, message)
    transmission_request = transmission_request_for_chat(chat, user)

    chat.tap do |me|
      me.answered = true
      me.last_contacted_by = user
    end.save!

    Transmissions::SendBatchService.new.enqueue_a_message(transmission_request.id, message, chat.destination, chat.owner)
  end

  def archive(chat_room)
    chat_room.archived = true
    chat_room.save!
  end

  protected

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

  def create_answer_message(content, destination, owner, sent_time)
    content = MessageContent.create(content: content);
    Message.create!(destination: destination, message_content: content, outgoing: false, owner: owner, sent_at: sent_time)
  end

  def transmission_request_for_chat(chat, user)
    TransmissionRequest.create!(user: user, owner: chat.owner, identification: 'chat_response')
  end
end
