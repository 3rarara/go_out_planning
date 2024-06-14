module Public::NotificationsHelper

  def transition_path(notification)
    case notification.action_type.to_sym
    when :commented_to_own_plan
      plan_path(notification.subject.plan, anchor: "comment-#{notification.subject.id}")
    when :liked_to_own_plan
      plan_path(notification.subject.plan)
    when :followed_me
      user_path(notification.subject.follower)
    end
  end

end
