class Plan < ApplicationRecord

  # アソシエーション
  belongs_to :user
  has_many :plan_details, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :plan_tags, dependent: :destroy
  has_many :tags, through: :plan_tags
  has_many :notifications, as: :subject, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  # 子モデル（plan_details）の属性を受入れ、更新や削除を許可する
  accepts_nested_attributes_for :plan_details, allow_destroy: true

  # バリデーション
  validates :title, presence: true, unless: :is_draft?

  # コールバック
  before_save :update_plan_search
  # after_commit :process_plan_image, on: [:create, :update], if: -> { plan_image.attached? }
  after_create_commit :notify_followers

  # スコープ
  scope :published, -> { where(is_draft: false) }
  scope :draft, -> { where(is_draft: true) }
  scope :active_users, -> { joins(:user).merge(User.active) }

  # 投稿画像
  has_one_attached :plan_image

  def get_plan_image(width, height)
    return unless plan_image.attached?
    plan_image.variant(resize_to_fill: [width, height]).processed
  end

  # いいねの確認
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.looks(range, words)
    query = joins(:user)
              .left_joins(:tags) # タグがない投稿も内部結合する
              .where(is_draft: false) # 下書き投稿を除く
              .where(users: { is_active: true }) # 退会ユーザーの投稿を除く

    # ,で区切った複数の文字列を検索
    if words.present?
      conditions = words.split(',').map(&:strip).compact.reject(&:empty?).map do |word|

        "(plans.plan_search LIKE '%#{word}%' OR tags.name LIKE '%#{word}%')"
      end

      query = query.where(conditions.join(" AND "))
    end
    query.distinct
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

  private

  # 検索用カラム保存
  def update_plan_search
    self.plan_search = "#{title} #{body} #{plan_details.map(&:title).join(' ')} #{plan_details.map(&:body).join(' ')} #{plan_details.map(&:address).join(' ')}"
  end

  # 通知機能
  def notify_followers
    return if self.is_draft
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