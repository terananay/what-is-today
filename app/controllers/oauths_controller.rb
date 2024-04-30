class OauthsController < ApplicationController
  skip_before_action :require_login
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    # すでにユーザー登録があればログイン
    if (@user = login_from(provider))
      redirect_to root_path, success: t('flash.google_login')
    else
      begin
        # 新規ユーザーを作成してログイン
        signup_and_login(provider)
        redirect_to root_path, success: t('flash.google_login')
      rescue
        redirect_to root_path, danger: t('flash.google_failed')
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

  def signup_and_login(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
  end
end
