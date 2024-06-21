module Public::NotificationsHelper

  def transition_path(notification)
    case notification.action_type.to_sym
    when :new_plan
      plan_path(notification.subject)
    when :commented_to_own_plan
      plan_path(notification.subject, anchor: "comment-#{notification.subject.id}")
    when :liked_to_own_plan
      plan_path(notification.subject.plan)
    when :followed_me
      user_path(notification.subject.follower)
    when :new_message
      user_path(notification.subject.user)
    when :hidden_plan
      plan_path(notification.subject)
    end
  end

end
