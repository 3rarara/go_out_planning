class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @active_users = User.active.order(created_at: :desc)
    @close_account_users = User.inactive.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_admin_user_path, notice: "ユーザー情報を変更しました"
    else
      flash.now[:alert] = "ユーザー情報を変更できませんでした"
      render 'edit'
    end
  end

  def destroy
    if @user.is_active == false
      @user.destroy
      redirect_to admin_users_path, notice: "ユーザーを削除しました"
    else
      flash.now[:alert] = "ユーザーを削除できませんでした"
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    @plans = @user.plans.all
  end

  def user_params
   params.require(:user).permit(:is_active)
  end

end
