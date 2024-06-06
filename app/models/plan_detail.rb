class PlanDetail < ApplicationRecord

  # アソシエーション
  belongs_to :plan

  # バリデーション
  validates :title, presence: true

end
