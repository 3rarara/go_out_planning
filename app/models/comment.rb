class Comment < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :plan

end
