class Admin::UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @plans = @user.plans.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      flash[:notice] = "ユーザー情報を変更しました。"
      redirect_to admin_user_path(user)
    else
      @user = User.find(params[:id])
      flash.now[:alert] = "ユーザー情報を変更できませんでした。"
      render 'edit'
    end
  end

  private

  def user_params
   params.require(:user).permit(:is_active)
  end

end
