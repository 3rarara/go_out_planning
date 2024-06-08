class Like < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :plan
  # バリデーション
  validates :user_id, uniqueness: {scope: :plan_id}
end
