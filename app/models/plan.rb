class Plan < ApplicationRecord

  # アソシエーション
  belongs_to :user
  has_many :plan_details, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :plan_tags, dependent: :destroy
  has_many :tags, through: :plan_tags
  has_many :notifications, as: :subject, dependent: :destroy

  # 子モデル（plan_details）の属性を受入れ、更新や削除を許可する
  accepts_nested_attributes_for :plan_details, allow_destroy: true

  # バリデーション
  validates :title, presence: true, unless: :is_draft?

  # いいねの確認
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "partial"
      @plan = Plan.where("title LIKE?","%#{word}%")
    end
  end

  # タグ機能
  def save_plan_tags(tags)
    # 現在のタグを取得し、nilの場合は空の配列を代入する
    current_tags = self.tags.pluck(:name)
    current_tags ||= []

    # 新しいタグの作成・更新
    tags.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name.strip)
      self.tags << tag unless self.tags.include?(tag)
    end

    # 削除されたタグの削除
    tags_to_delete = current_tags - tags
    self.tags.where(name: tags_to_delete).destroy_all
  end

  # 通知機能
  after_create_commit :notify_followers

  private

  def notify_followers
    follower_ids = user.followers.pluck(:id)
    if follower_ids.any?
      notifications = follower_ids.map do |follower_id|
        {
          subject_type: 'Plan',
          subject_id: self.id,
          user_id: follower_id,
          action_type: 'new_plan',
          created_at: Time.current,
          updated_at: Time.current
        }
      end

      Notification.insert_all(notifications)
    end
  end
end
