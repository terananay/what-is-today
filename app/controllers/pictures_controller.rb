# frozen_string_literal: true

# controllers/pictures_controller.rb
class PicturesController < ApplicationController
  def new
    @picture = Picture.new
  end

  def index
    @pictures = current_user.pictures
  end

  def create
    begin
      picture_params[:images].each do |image|
        picture = current_user.pictures.build
        picture.image.attach(image)
        picture.save!
      end
      redirect_to calendar_pictures_path
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Failed to save picture."
      render :new
    end
  end

  private

  def picture_params
    params.require(:picture).permit(:title, :memo, images: [])
  end
end
