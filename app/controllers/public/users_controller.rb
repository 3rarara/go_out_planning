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
