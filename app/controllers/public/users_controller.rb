class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def mypage
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
  end

  private

  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
