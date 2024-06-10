class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :likes]
  before_action :set_current_user, except: [:show]
  before_action :user_is_active, only: [:show]
  before_action :ensure_current_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def mypage
    @plans = current_user.plans.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to mypage_path
    else
      flash.now[:alert] = "ユーザー情報を編集できませんでした"
      render 'edit'
    end
  end

  def confirm
  end

  def close_account
    if @user.update(is_active: false)
      reset_session
      flash[:notice] = "退会処理を実行しました"
      redirect_to new_user_registration_path
    else
      flash.now[:alert] = "退会処理を実行できませんでした"
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    @plans = @user.plans.all
  end

  def likes
    likes = Like.where(user_id: @user.id).pluck(:plan_id)
    @like_plans = Plan.find(likes)
    @plan = Plan.find(params[:id])
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
    unless user.id == current_user.id
      redirect_to plans_path
    end
  end

  def user_is_active
    user = User.find(params[:id])
    if user.is_active?
    else
      flash[:alert] = "指定のユーザーは退会済みです"
      redirect_to mypage_path
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
