class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, except: [:show]
  before_action :ensure_current_user, only: [:edit, :update]

  def mypage
    # ユーザーデータの取得
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
    @user = User.find(params[:id])
    # ユーザーデータの取得
    fetch_user_data

    if @user.is_active?
      redirect_to mypage_path if current_user == @user
    else
      redirect_to mypage_path, alert: "指定のユーザーは退会済みです"
    end
  end

  private

  def set_current_user
    @user = current_user
  end

  def ensure_current_user
    redirect_to plans_path unless @user == current_user
  end

  def fetch_user_data
    @plans = @user.plans.where(is_draft: false)
    liked_ids = @user.likes.pluck(:plan_id)
    @like_plans = Plan.where(id: liked_ids, is_draft: false)
  end

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

end
