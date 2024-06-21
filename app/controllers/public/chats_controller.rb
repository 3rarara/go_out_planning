class Public::ChatsController < ApplicationController

  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    # もしuser_roomsが空でないなら
    unless user_room.nil?
      @room = user_room.room
    else
      # user_roomsが空なら@roomを作成
      @room = Room.create
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end

    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    room = Room.find(params[:chat][:room_id])
    @chats = room.chats
    @chat = current_user.chats.new(chat_params)
    if @chat.save
    else
      flash.now[:alert] = "メッセージを送信できませんでした"
    end
  end

  # チャットルーム一覧
  def index
    @user_rooms  = current_user.rooms.includes(:users).map do |room|
    other_user = room.users.where.not(id: current_user.id).first
      { room: room, other_user: other_user }
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

end