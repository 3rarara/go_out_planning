class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # ユーザーのすべての通知を取得し、作成日時の降順に並べる
    @notifications = current_user.notifications.order(created_at: :desc)
    @notifications_read = @notifications.where(read: false)
  end

  def mark_all_as_read
    current_user.notifications.update_all(read: true)
    redirect_to notifications_path, notice: "全ての通知を既読にしました"
  end

  def destroy
    @notifications = current_user.notifications.destroy_all
    redirect_to notifications_path, notice: "全ての通知を削除しました"
  end

end
