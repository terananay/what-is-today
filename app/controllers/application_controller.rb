# frozen_string_literal: true

# controllers/application_controller.rb
class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login
  before_action :set_user

  private

  def not_authenticated
    redirect_to login_path, danger: t('flash.please_login')
  end

  def set_user
    @user = current_user if logged_in?
  end

  def clear_pictures_from_session
    session.delete(:pictures_by_year)
  end
end
