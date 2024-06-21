class Room < ApplicationRecord

  # アソシエーション
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :users, through: :user_rooms

end
