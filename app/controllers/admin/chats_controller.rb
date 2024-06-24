class Admin::ChatsController < ApplicationController

  def show
    @room = Room.includes(:users, :chats).find(params[:id])
    @users = @room.users
    @chats = @room.chats
  end

  # チャットルーム一覧
  def index
    @rooms = Room.includes(:users).all
  end

end