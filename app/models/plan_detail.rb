class PlanDetail < ApplicationRecord

  # アソシエーション
  belongs_to :plan

  # バリデーション
  validates :title, presence: true, unless: :plan_is_draft?

  # 下書き時、バリデーションをスキップ
  def plan_is_draft?
    self.plan.is_draft?
  end

  # GoogleMap API
  # addressカラムを緯度経度に変換
  geocoded_by :address
  # latitudeカラム・longitudeカラムに緯度・経度の値を入力
  after_validation :geocode

end
