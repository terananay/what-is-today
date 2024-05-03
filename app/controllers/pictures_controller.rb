# frozen_string_literal: true

# controllers/pictures_controller.rb
class PicturesController < ApplicationController
  def new; end

  def create
    params[:images].each do |image|
      current_user.pictures.create(image:)
    end
    redirect_to calendar_pictures_path
  end

  private

  def message_params
    params.require(:message).permit(:title, :memo, images: [])
  end
end
