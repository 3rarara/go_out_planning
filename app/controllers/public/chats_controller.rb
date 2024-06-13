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
    @chat = current_user.chats.new(chat_params)
    if @chat.save
      redirect_to request.referer
    else
      redirect_to request.referer, alert: "メッセージを送信できませんでした"
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

end