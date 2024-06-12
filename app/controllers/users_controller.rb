# frozen_string_literal: true

# controllers/users_controller.rb
class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :clear_pictures_from_session, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      auto_login(@user)
      redirect_to new_picture_path, success: t('flash.user_create')
    else
      flash.now[:danger] = t('flash.user_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      @user.destroy!
      reset_session
      redirect_to root_path, success: t('flash.user_destroy')
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
