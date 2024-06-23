# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin データの作成
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

# タグのサンプルデータ作成
Tag.find_or_create_by!(name: "大阪")
Tag.find_or_create_by!(name: "東京")
Tag.find_or_create_by!(name: "鎌倉")
Tag.find_or_create_by!(name: "カフェ")
Tag.find_or_create_by!(name: "デート")
Tag.find_or_create_by!(name: "旅行")
Tag.find_or_create_by!(name: "観光")
Tag.find_or_create_by!(name: "食べ物")
Tag.find_or_create_by!(name: "アクティビティ")

# Plans データの作成
Plan.find_or_create_by!(title: "大阪旅行") do |plan|
  plan.body = "大阪旅行で御朱印巡りをしました！おすすめのお寺や神社を紹介してます！移動手段は電車です！。"
  plan.user = olivia

  # タグの関連付け
  plan.tags << Tag.find_by(name: "大阪")
  plan.tags << Tag.find_by(name: "旅行")
  plan.tags << Tag.find_by(name: "観光")

  plan.plan_details.build(
    title: "大阪駅 到着",
    body: "10:00集合 徒歩10分移動"
  )

  plan.plan_details.build(
    title: "＊＊神社 到着",
    body: "10:10早速御朱印を１つゲット",
    address: "大阪府大阪市中央区１−１"
  )

  # plan_search カラムの設定
  plan.plan_search = "#{plan.title} #{plan.body} #{plan.plan_details.map(&:title).join(' ')} #{plan.plan_details.map(&:body).join(' ')} #{plan.plan_details.map(&:address).join(' ')} #{plan.tags.map(&:name).join(' ')}"
end

Plan.find_or_create_by!(title: "東京デートおすすめスポット️") do |plan|
  plan.body = "東京でのカフェ巡り！いろんなカフェを紹介してます！デートにおすすめです。"
  plan.user = james

  # タグの関連付け
  plan.tags << Tag.find_by(name: "東京")
  plan.tags << Tag.find_by(name: "カフェ")

  plan.plan_details.build(
    title: "東京駅 到着",
    body: "11:00集合 徒歩5分移動"
  )

  plan.plan_details.build(
    title: "＊＊カフェ 到着",
    body: "11:05 早めのランチ",
    address: "東京都千代田区丸の内１丁目"
  )

  # plan_search カラムの設定
  plan.plan_search = "#{plan.title} #{plan.body} #{plan.plan_details.map(&:title).join(' ')} #{plan.plan_details.map(&:body).join(' ')} #{plan.plan_details.map(&:address).join(' ')} #{plan.tags.map(&:name).join(' ')}"
end

Plan.find_or_create_by!(title: "鎌倉のお寺へ行くぞ️") do |plan|
  plan.body = "鎌倉でまったりデートしました。"
  plan.user = lucas

  # タグの関連付け
  plan.tags << Tag.find_by(name: "鎌倉")
  plan.tags << Tag.find_by(name: "デート")

  plan.plan_details.build(
    title: "鎌倉駅 到着",
    body: "11:00集合 徒歩20分移動"
  )

  plan.plan_details.build(
    title: "＊＊寺 到着",
    body: "11:05 11:00御朱印ゲット！",
    address: "神奈川県鎌倉市１丁目１−１"
  )

  # plan_search カラムの設定
  plan.plan_search = "#{plan.title} #{plan.body} #{plan.plan_details.map(&:title).join(' ')} #{plan.plan_details.map(&:body).join(' ')} #{plan.plan_details.map(&:address).join(' ')} #{plan.tags.map(&:name).join(' ')}"
end

puts '初期データを追加しました'