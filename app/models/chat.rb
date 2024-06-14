class Chat < ApplicationRecord

  # アソシエーション
  belongs_to :user
  belongs_to :room
  has_many :notification, as: :subject, dependent: :destroy

  # 通知コールバック
  after_create_commit :create_notifications

  # バリデーション
  validates :message, presence: true, length: { maximum: 140 }

  private

  # 通知機能
  def create_notifications
    room = self.room
    recipient_user = room.users.where.not(id: self.user.id).first
    Notification.create(subject: self, user: recipient_user, action_type: :new_message)
  end

end
