class Like < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :plan
  has_one :notification, as: :notifiable, dependent: :destroy

  # バリデーション
  validates :user_id, uniqueness: {scope: :plan_id}

  # 通知機能
  after_create do
    create_notification(user_id: plan.user_id)
  end

end