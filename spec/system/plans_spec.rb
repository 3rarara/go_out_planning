require 'rails_helper'

describe '投稿のテスト' do
  let!(:plan){ create(:plan,title:'hoge',book:'body') }
    before do
      visit root_path
    end

  end