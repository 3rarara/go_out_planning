class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :likes]
  before_action :set_current_user, except: [:show]
  before_action :user_is_active, only: [:show]
  before_action :ensure_current_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def mypage
    @plans = current_user.plans.all
    likes = Like.where(user_id: @user.id).pluck(:plan_id)
    @like_plans = Plan.find(likes)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: "ユーザー情報を変更しました"
    else
      flash.now[:alert] = "ユーザー情報を変更できませんでした"
      render 'edit'
    end
  end

  def confirm
  end

  def close_account
    if @user.update(is_active: false)
      reset_session
      redirect_to new_user_registration_path, notice: "退会処理を実行しました"
    else
      flash.now[:alert] = "退会処理を実行できませんでした"
      render 'edit'
    end
  end

  def show
    @plans = @user.plans.all
    likes = Like.where(user_id: @user.id).pluck(:plan_id)
    @like_plans = Plan.find(likes)
    if current_user == @user
      redirect_to mypage_path
    end
  end

  def likes
    likes = Like.where(user_id: @user.id).pluck(:plan_id)
    @like_plans = Plan.find(likes)
    @plan = Plan.find(params[:id])
  end

  def drafts
   @drafts = current_user.plans.where(is_draft: true)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_current_user
    @user = current_user
  end

  def ensure_current_user
    user = current_user
    unless user == current_user
      redirect_to plans_path
    end
  end

  def user_is_active
    user = User.find(params[:id])
    if user.is_active?
    else
      redirect_to mypage_path, alert: "指定のユーザーは退会済みです"
    end
  end

  def ensure_guest_user
    set_current_user
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

end
