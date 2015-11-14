class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @chat_rooms = safe_scope.joins(:destination).where(archived: false).where(answered: false)
    render layout: false
  end

  def answer
    chat_room = safe_scope.find(params[:id])
    message = params[:message]
    ChatRoomService.new.reply_to_destination(chat_room, current_user, message)
    render status: :created, nothing: true
  end

  def archive
    chat_room = safe_scope.find(params[:id])
    ChatRoomService.new.archive(chat_room)
    render status: :created, nothing: true
  end


  protected
  def safe_scope
    ChatRoom.all.of_owner(current_user) # TODO current_owner
  end
end
