class Tag < ApplicationRecord

  # アソシエーション
  has_many :plan_tags, dependent: :destroy
  has_many :plans, through: :plan_tags

  # バリデーション
  validates :name, presence: true, length: {maximum:20}

end
