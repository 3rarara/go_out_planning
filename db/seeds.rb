# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.find_or_create_by!(email: ENV['ADMIN_EMAIL']) do |admin|
  admin.password = ENV['ADMIN_PASSWORD']
end

olivia = User.find_or_create_by!(email: "olivia@example.com") do |user|
  user.name = "olivia"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end

james = User.find_or_create_by!(email: "james@example.com") do |user|
  user.name = "james"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end

lucas = User.find_or_create_by!(email: "lucas@example.com") do |user|
  user.name = "lucas"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end

# Plan.find_or_create_by!(title: "大阪旅行") do |plan|
#   plan.body = "大阪旅行で御朱印巡りをしました！おすすめのお寺や神社を紹介してます！移動手段は電車です！。"
#   plan.user = olivia

#   plan.plan_details.build(
#     title: "大阪駅 到着",
#     body: "10:00集合 徒歩10分移動"
#   )

#   plan.plan_details.build(
#     title: "＊＊神社 到着",
#     body: "10:10早速御朱印を１つゲット"
#   )
# end

# Plan.find_or_create_by!(title: "東京デートおすすめスポット️") do |plan|
#   plan.body = "東京でのカフェ巡り！いろんなカフェを紹介してます！デートにおすすめです。"
#   plan.user = james

#   plan.plan_details.build(
#     title: "東京駅 到着",
#     body: "11:00集合 徒歩5分移動"
#   )

#   plan.plan_details.build(
#     title: "＊＊カフェ 到着",
#     body: "11:05 早めのランチ"
#   )
# end

# Plan.find_or_create_by!(title: "鎌倉のお寺へ行くぞ️") do |plan|
#   plan.body = "鎌倉でまったりデートしました。"
#   plan.user = lucas

#   plan.plan_details.build(
#     title: "鎌倉駅 到着",
#     body: "11:00集合 徒歩20分移動"
#   )

#   plan.plan_details.build(
#     title: "＊＊寺 到着",
#     body: "11:05 11:00御朱印ゲット！"
#   )
# end

puts '初期データを追加しました'