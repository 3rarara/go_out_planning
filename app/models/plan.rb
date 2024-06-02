class Plan < ApplicationRecord

  # アソシエーション
  belongs_to :user
  has_many :plan_details, dependent: :destroy
  # 子モデル（plan_details）の属性を受入れ、更新や削除を
  accepts_nested_attributes_for :plan_details, allow_destroy: true

end
