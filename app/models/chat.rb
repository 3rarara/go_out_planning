class Chat < ApplicationRecord

  # アソシエーション
  belongs_to :user
  belongs_to :room

  # バリデーション
  validates :message, presence: true, length: { maximum: 140 }
end
