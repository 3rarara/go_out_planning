
# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # callback for google
  def google_oauth2
    callback_for(:google)
  end

  def callback_for(provider)
    # 先ほどuser.rbで記述したメソッド(from_omniauth)をここで使っています
    # 'request.env["omniauth.auth"]'この中にgoogoleアカウントから取得したメールアドレスや、名前と言ったデータが含まれています
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
  end

  def failure
    redirect_to root_path
  end
end

