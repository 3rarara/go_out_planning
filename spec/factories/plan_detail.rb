FactoryBot.define do
  factory :plan_detail do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.sentence }
    # ここでPlanオブジェクトを関連付ける
    plan
  end
end