class Comment < ApplicationRecord

  # アソシエーション
  belongs_to :user
  belongs_to :plan
  has_many :notification, as: :subject, dependent: :destroy

  # 通知コールバック
  after_create_commit :create_notifications

  # バリデーション
  validates :comment, presence: true

  private

  def create_notifications
    Notification.create(subject: self, user: plan.user, action_type: :commented_to_own_plan)
  end

end
