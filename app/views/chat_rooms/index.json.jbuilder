json.chat_rooms @chat_rooms do  |chat_room|
  json.id chat_room.id
  json.answered chat_room.answered
  json.archived chat_room.archived
  
  user = chat_room.last_contacted_by
  json.last_contacted_by do 
    json.email user.email
    json.id    user.id
  end

  destination = chat_room.destination
  json.destination do 
    json.id destination.id
    json.address destination.address
  end

  json.messages do
    json.total chat_room.messages.count # TODO counter_cache
    json.recent chat_room.recent_messages.joins(:message_content) do |message|
      json.created_at message.created_at
      json.content message.message_content.content
    end
  end
end
