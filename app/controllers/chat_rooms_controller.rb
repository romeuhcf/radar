class ChatRoomsController < ApplicationController
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped
  before_action :authenticate_user!

  def index
    @chat_rooms = safe_scope.includes(:destination, :owner).where(archived: false).where(answered: false)
    render layout: false
  end

  def answer
    chat_room = safe_scope.find(params[:id])
    authorize(chat_room)
    message = params[:message]
    ChatRoomService.new.reply_to_destination(chat_room, current_user, message)
    render status: :created, nothing: true
  end

  def archive
    chat_room = safe_scope.find(params[:id])
    authorize(chat_room)
    ChatRoomService.new.archive(chat_room)
    render status: :created, nothing: true
  end


  protected
  def safe_scope
    policy_scope(ChatRoom)
  end
end
