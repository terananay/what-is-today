# frozen_string_literal: true

# controllers/oauthes_controller.rb
class OauthsController < ApplicationController
  skip_before_action :require_login
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    # すでにユーザー登録があればログイン
    if (@user = login_from(auth_params[:provider]))
      redirect_to daily_pictures_pictures_path, success: t('flash.google_login')
    else
      begin
        # 新規ユーザーを作成してログイン
        signup_and_login(auth_params[:provider])
        redirect_to new_picture_path, success: t('flash.google_login')
      rescue StandardError
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
