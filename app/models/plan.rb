class Plan < ApplicationRecord

  # アソシエーション
  belongs_to :user
  has_many :plan_details, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # 子モデル（plan_details）の属性を受入れ、更新や削除を許可する
  accepts_nested_attributes_for :plan_details, allow_destroy: true

  # バリデーション
  validates :title, presence: true

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @plan = Plan.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @plan = Plan.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @plan = Plan.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @plan = Plan.where("title LIKE?","%#{word}%")
    else
      @plan = Plan.all
    end
  end

end
