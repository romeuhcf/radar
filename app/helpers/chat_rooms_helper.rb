module ChatRoomsHelper
  def message_direction(message)
    message.outgoing ? 'out' : 'in'
  end

  def chat_direction(chat)
    chat.answered ? 'out' : 'in'
  end
end
