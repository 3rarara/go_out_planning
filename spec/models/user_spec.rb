require 'rails_helper'

RSpec.describe User, 'モデルのテスト', type: :model do
  describe '実際に保存してみる' do
    it "有効なユーザー内容の場合は保存されるか" do
      expect(FactoryBot.build(:user)).to be_valid
    end

    it "デフォルトが有効ユーザーか" do
      user = FactoryBot.build(:user)
      expect(user.is_active).to be(true)
    end

    context "バリデーション" do
      it "nameが空白の場合は無効であること" do
        user = FactoryBot.build(:user, name: nil)
        expect(user).to_not be_valid
      end

      it "emailが空白の場合は無効であること" do
        user = FactoryBot.build(:user, email: nil)
        expect(user).to_not be_valid
      end

      it "emailが重複している場合は無効であること" do
        FactoryBot.create(:user, email: "test@example.com")
        user = FactoryBot.build(:user, email: "test@example.com")
        expect(user).to_not be_valid
      end
    end

  end
end