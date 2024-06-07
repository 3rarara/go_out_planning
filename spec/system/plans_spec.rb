require 'rails_helper'

  RSpec.describe '新規登録画面のテスト', type: :system do
    let(:user_attributes) { attributes_for(:user) }

    before do
      visit new_user_registration_path
    end

    context '表示の確認' do
      it '会員登録画面に適切なフォームが表示されているか' do
        expect(page).to have_field('user[name]')
        expect(page).to have_field('user[email]')
        expect(page).to have_field('user[password]')
        expect(page).to have_field('user[password_confirmation]')
        expect(page).to have_button('登録')
      end
    end

    context '登録処理のテスト' do
      it '正しい情報で登録が成功すること' do
        fill_in 'user[name]', with: user_attributes[:name]
        fill_in 'user[email]', with: user_attributes[:email]
        fill_in 'user[password]', with: user_attributes[:password]
        fill_in 'user[password_confirmation]', with: user_attributes[:password]

        expect { click_button '登録' }.to change(User, :count).by(1)
        expect(page).to have_content 'Welcome! You have signed up successfully.'
      end

      it '誤った情報で登録処理が失敗すること' do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''

        expect { click_button '登録' }.not_to change(User, :count)
        expect(page).to have_content 'errors prohibited this user from being saved:'
      end

    end
  end

  describe 'ゲストログイン機能のテスト' do
    before do
      visit root_path
    end

    context 'ゲストログインボタンの表示' do
      it 'トップ画面にゲストログインが表示されていること' do
        expect(page).to have_link 'ゲストログイン', href: '/users/guest_sign_in'
      end
    end

    context 'ゲストログインのテスト' do
      it 'ゲストログインボタンをクリックするとログインされること' do
        click_link 'ゲストログイン'
        expect(page).to have_content 'guestuserでログインしました。'
      end
    end
  end

  describe 'ログイン画面のテスト' do
    let(:user) { create(:user) }
    let!(:plan) { create(:plan, title: 'hoge', body: 'body', user: user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'

      visit root_path
    end

    context '表示の確認' do
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
      it 'トップ画面(root_path)に一覧ページへのリンクが表示されているか' do
        expect(page).to have_link "", href: plans_path
      end
    end
  end

  describe '一覧のテスト' do
    let(:user) { create(:user) }
    let!(:plan){ create(:plan,title:'hoge',body:'body', user: user) }
    before do
      visit plans_path
    end
    context '表示の確認' do
      it '投稿されたものが表示されているか' do
        expect(page).to have_content plan.title
        expect(page).to have_link plan.title
      end
    end
  end