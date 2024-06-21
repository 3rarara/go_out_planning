class Like < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :plan
  has_one :notification, as: :subject, dependent: :destroy

  # 通知コールバック
  after_create_commit :create_notifications

  # バリデーション
  validates :user_id, uniqueness: {scope: :plan_id}

  private

  # 通知機能
  def create_notifications
    Notification.create(subject: self, user: plan.user, action_type: :liked_to_own_plan)
  end

end