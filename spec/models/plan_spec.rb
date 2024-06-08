require 'rails_helper'

RSpec.describe Plan, 'モデルのテスト', type: :model do
  describe '実際に保存してみる' do
    let(:user) { create(:user) }

    it "有効なユーザー内容の場合は保存されるか" do
      expect(FactoryBot.build(:plan, user: user)).to be_valid
    end

    # PlanDetailに関するテストを追加
    let(:user) { create(:user) }
    it "関連するPostDetailが保存されるか" do
      plan = FactoryBot.create(:plan, user: user)
      plan.plan_details.each do |plan_detail|
        expect(plan_detail).to be_valid
      end
    end

    context "バリデーション" do
      it "Planのtitleが空白の場合は無効であること" do
        plan = FactoryBot.build(:plan, title: nil)
        expect(plan).to_not be_valid
      end

      it "PlanDetailのtitleが空白の場合は無効であること" do
        plan = FactoryBot.build(:plan_detail, title: nil)
        expect(plan).to_not be_valid
      end
    end

  end
end