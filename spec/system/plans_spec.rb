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
        fill_in 'user_name', with: user_attributes[:name]
        fill_in 'user_email', with: user_attributes[:email]
        fill_in 'user_password', with: user_attributes[:password]
        fill_in 'user_password_confirmation', with: user_attributes[:password]

        expect { click_button '登録' }.to change(User, :count).by(1)
        expect(page).to have_content 'アカウント登録が完了しました'
      end
      it '誤った情報で登録処理が失敗すること' do
        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: ''
        fill_in 'user_password_confirmation', with: ''

        expect { click_button '登録' }.not_to change(User, :count)
        expect(page).to have_content 'エラーが発生したため'
      end
    end
  end

  describe 'ゲストログイン機能のテスト' do
    before do
      visit new_user_session_path
    end
    context 'ゲストログインボタンの表示' do
      it 'ログイン画面にゲストログインが表示されていること' do
        expect(page).to have_link 'ゲストログイン', href: '/users/guest_sign_in'
      end
    end
    context 'ゲストログインのテスト' do
      it 'ゲストログインボタンをクリックするとログインされること' do
        click_link 'guest_login_btn'
        expect(page).to have_content 'guestuserでログインしました。'
      end
    end
  end

  describe 'ログイン画面のテスト' do
    let(:user) { create(:user) }
    let!(:plan) { create(:plan, title: 'hoge', body: 'body', user: user) }

    before do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'login_btn'
      visit root_path
    end
    context '表示の確認' do
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
      it 'トップ画面(root_path)に一覧ページへのリンクが表示されているか' do
        expect(page).to have_link "", href: root_path
      end
    end
  end

  describe '一覧のテスト' do
    let(:user) { create(:user) }
    let!(:plan){ create(:plan,title:'hoge',body:'body', user: user) }
    before do
      visit plans_path
    end
    context '投稿の確認' do
      it '投稿されたものが一覧表示されているか' do
        expect(page).to have_content plan.title
        expect(page).to have_link plan.title
      end
    end
  end

    describe "投稿画面(new_plan_path)のテスト" do
      let(:user) { create(:user) }
      before do
        sign_in user
        visit new_plan_path
      end
    context '表示の確認' do
      it 'new_plan_pathが"/plans/new"であるか' do
        expect(current_path).to eq('/plans/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_selector('button[type="submit"]')
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        # binding.pry
        fill_in 'plan[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'plan[body]', with: Faker::Lorem.characters(number:20)
        fill_in 'plan[plan_details_attributes][0][title]', with: Faker::Lorem.sentence
        fill_in 'plan[plan_details_attributes][0][body]', with: Faker::Lorem.sentence
        find('button[type="submit"]').click
        expect(page).to have_current_path plan_path(Plan.last)
      end
    end
  end

  describe '詳細画面のテスト' do
    let(:user) { create(:user) }
    let!(:plan) { create(:plan, user: user) }
    context '表示の確認' do
      before do
        sign_in user
        visit plan_path(plan)
      end
      it '削除リンクが存在しているか' do
        expect(page).to have_selector("a[href='/plans/#{plan.id}'][data-method='delete']")
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_selector("a[href='/plans/#{plan.id}/edit']")
      end
      context 'リンクの遷移先の確認' do
        let(:user) { create(:user) }
        let!(:plan) { create(:plan, user: user) }
        before do
          sign_in user
          visit edit_plan_path(plan)
        end
        it '編集後の遷移先は詳細画面か' do
          find('button[type="submit"]').click
          expect(current_path).to eq("/plans/#{plan.id}")
        end
      end
      context 'plan削除のテスト' do
        it 'planの削除' do
          expect{ plan.destroy }.to change{ Plan.count }.by(-1)
        end
      end
    end
  end

  describe '編集画面のテスト' do
    let!(:user) { create(:user) }
    let!(:plan){ create(:plan,title:'hoge',body:'body', user: user) }
    context '表示の確認' do
      before do
        sign_in user
        visit edit_plan_path(plan)
      end
      it '編集前のタイトルと本文がフォームに表示(セット)されている' do
        expect(page).to have_field 'plan[title]', with: plan.title
        expect(page).to have_field 'plan[body]', with: plan.body
        # binding.pry
        expect(page).to have_field 'plan[plan_details_attributes][0][title]', with: PlanDetail.last.title
        expect(page).to have_field 'plan[plan_details_attributes][0][body]', with: PlanDetail.last.body
      end
      it '保存ボタンが表示される' do
        expect(page).to have_selector('button[type="submit"]')
      end
      context '更新処理に関するテスト' do
        it '更新後のリダイレクト先は正しいか' do
            fill_in 'plan[title]', with: Faker::Lorem.characters(number:5)
            fill_in 'plan[body]', with: Faker::Lorem.characters(number:20)
            fill_in 'plan[plan_details_attributes][0][title]', with: Faker::Lorem.sentence
            fill_in 'plan[plan_details_attributes][0][body]', with: Faker::Lorem.sentence
            find('button[type="submit"]').click
            expect(page).to have_current_path plan_path(plan)
        end
      end
    end
  end