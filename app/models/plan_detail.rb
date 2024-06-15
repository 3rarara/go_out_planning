class PlanDetail < ApplicationRecord

  # アソシエーション
  belongs_to :plan

  # バリデーション
  validates :title, presence: true

  # Google.map API
  # addressカラムを緯度経度に変換
  geocoded_by :address
  # latitudeカラム・longitudeカラムに緯度・経度の値を入力
  after_validation :geocode

end
