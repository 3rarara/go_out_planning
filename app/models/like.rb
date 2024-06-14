class Like < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :plan
  has_one :notification, as: :subject, dependent: :destroy

  # バリデーション
  validates :user_id, uniqueness: {scope: :plan_id}

  # 通知コールバック
  after_create_commit :create_notifications

  private

  # 通知機能
  def create_notifications
    Notification.create(subject: self, user: self.plan.user, action_type: :liked_to_own_plan)
  end

end