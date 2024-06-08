FactoryBot.define do
  factory :plan do
    title { Faker::Lorem.characters(number: 5) }
    body { Faker::Lorem.characters(number: 20) }

    # plan_detailを追加
    after(:build) do |plan|
      plan.plan_details << FactoryBot.build(:plan_detail, plan: plan)
    end
  end
end