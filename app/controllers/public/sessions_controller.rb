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

  # ログイン失敗後は def failed に飛ぶように変更
  def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
  end

  # ログイン失敗の時は直前のURLにリダイレクトする
  def failed
    flash[:alert] = "入力情報が正しくありません"
    redirect_to request.referer
  end

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
    root_path
  end

  # protected
  private

  # ログイン失敗後の処理指定
  def auth_options
    { scope: resource_name, recall: "#{controller_path}#failed" }
  end

  # アクティブ判断メソッド
  def user_status
    return if params[:user].nil?
    #emailからアカウントを１件取得
    user = User.find_by(email: params[:user][:email])
    return if user.nil?
    return unless user.valid_password?(params[:user][:password])
    return if user.is_active?
    redirect_to new_user_registration_path, alert: "退会済みです。別のメールアドレスをお使いください。"
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
