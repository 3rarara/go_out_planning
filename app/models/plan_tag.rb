class PlanTag < ApplicationRecord

  # アソシエーション
  belongs_to :plan
  belongs_to :tag

end
