class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def edit
    @plans = @user.plans.all
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を変更しました。"
      redirect_to edit_admin_user_path
    else
      @plans = @user.plans.all
      flash.now[:alert] = "ユーザー情報を変更できませんでした。"
      render 'edit'
    end
  end

  def destroy
    if @user.is_active == false
      @user.destroy
      flash[:notice] = "ユーザーを削除しました。"
      redirect_to root_path
    else
      @plans = @user.plans.all
      flash.now[:alert] = "ユーザーを削除できませんでした。"
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
   params.require(:user).permit(:is_active)
  end

end
