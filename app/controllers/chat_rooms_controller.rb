class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @chat_rooms = ChatRoom.all.of_owner(current_user).joins(:destination).where(archived: false).where(answered: false) # TODO - curent owner
    render layout: false
  end
end
