class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_current_user
  before_action :ensure_current_user, only: [:edit, :update]

  def mypage
    @plans = current_user.plans.all
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to mypage_path
  end

  def confirm
  end

  def close_account
    @user.update(is_active: false)
    reset_session
    # flash[:notice] = "退会処理を実行しました"
    redirect_to new_user_registration_path
  end

  def show
    @user = User.find(params[:id])
    @plans = @user.plans.all
  end

  private

  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

  def ensure_current_user
    user = current_user
    unless user.id == current_user.id
      redirect_to plans_path
    end
  end

end
