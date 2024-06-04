# frozen_string_literal: true

# app/controllers/user_sessions_controller.rb
class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  before_action :clear_pictures_from_session, only: [:destroy]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to daily_pictures_pictures_path, success: t('flash.login')
    else
      flash.now[:danger] = t('flash.login_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other, success: t('flash.logout')
  end

  private

  def clear_pictures_from_session
    session.delete(:pictures_by_year)
  end
end
