class ApplicationController < ActionController::Base
  before_action :set_unread_notifications_count

  private

  def set_unread_notifications_count
    @unread_notifications_count = user_signed_in? ? current_user.notifications.where(read: false).count : 0
  end
end
