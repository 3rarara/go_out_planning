# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :user_status, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # ログイン後トップページへ
  def after_sign_in_path_for(resource)
    root_path
  end

  # ログアウト後ログインページへ
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  # protected
  private
  # アクティブ判断メソッド
  def user_status
    #emailからアカウントを１件取得
    user = User.find_by(email: params[:user][:email])
    return if user.nil?
    return unless user.valid_password?(params[:user][:password])
    return if user.is_active?
    flash[:alert] = "退会済みです。別のメールアドレスをお使いください。"
    redirect_to new_user_registration_path
  end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
