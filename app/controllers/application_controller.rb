class ApplicationController < ActionController::Base
  before_action :set_unread_notifications_count
  before_action :set_unread_chats_count

  private

  def set_unread_notifications_count
    @unread_notifications_count = user_signed_in? ? current_user.notifications.where(read: false).count : 0
  end

  def set_unread_chats_count
    if user_signed_in?
      # current_userが参加している全てのルームを取得
      room_ids = current_user.user_rooms.pluck(:room_id)
      # ルーム内でcurrent_userが送信者ではない、未読のチャットをカウント
      @unread_chats_count = Chat.where(room_id: room_ids, read: false).where.not(user_id: current_user.id).count
    else
      @unread_chats_count = 0
    end
  end

end
