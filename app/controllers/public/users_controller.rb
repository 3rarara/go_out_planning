class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, except: [:show]
  before_action :set_user, only: [:show]
  before_action :ensure_current_user, only: [:edit, :update]
  before_action :check_user_active, only: [:show]

  def mypage
    fetch_user_data
  end

  def edit
    if @user.guest_user?
      redirect_to user_path(@user) , notice: "ゲストユーザーはプロフィールを編集できません"
    end
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
    if @user.close_account
      reset_session
      redirect_to new_user_registration_path, notice: "退会処理を実行しました"
    else
      flash.now[:alert] = "退会処理を実行できませんでした"
      render 'edit'
    end
  end

  def show
    fetch_user_data

    if current_user?(@user)
      redirect_to mypage_path
    end
  end

  private

  def set_current_user
    @user = current_user
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_current_user
    unless current_user?(@user)
      redirect_to mypage_path
    end
  end

  def check_user_active
    unless @user.is_active?
      redirect_to mypage_path, alert: "指定のユーザーは退会済みです"
    end
  end

  def fetch_user_data
    @plans = @user.plans.published.order(created_at: :desc)
    @like_plans = Plan.joins(:likes)
                      .where(likes: { user_id: @user.id })
                      .published
                      .order('likes.created_at DESC')
  end

  def current_user?(user)
    user == current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

end
