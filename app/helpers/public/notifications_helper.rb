module Public::NotificationsHelper
  
  def notification_message(notification)
    case notification.notifiable_type
    when "Plan"
      "フォローしている#{notification.notifiable.user.name}さんが#{notification.notifiable.title}を投稿しました"
    else
      "投稿した#{notification.notifiable.plan.title}が#{notification.notifiable.user.name}さんにいいねされました"
    end
  end
  
end
