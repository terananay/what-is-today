# frozen_string_literal: true

# controllers/pictures_controller.rb
class PicturesController < ApplicationController
  def new
    @picture = Picture.new
  end

  def index
    @pictures = current_user.pictures.with_attached_image
  end

  def create
    user_checksums = current_user.pictures.checksums.pluck('active_storage_blobs.checksum')
    if process_images(user_checksums)
      redirect_to calendar_pictures_path, success: t('flash.picture_create')
    else
      flash.now[:error] = t('flash.picture_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @picture = current_user.pictures.find(params[:id])
    @picture.destroy
    flash.now[:success] = t('flash.delete')
  end

  private

  def picture_params
    params.require(:picture).permit(:title, :memo, images: [])
  end

  def params_nil?
    if params[:picture].nil?
      @picture = current_user.pictures.build
      @picture.valid?
      return true
    end
    false
  end

  def process_images(user_checksums)
    return false if params_nil?

    picture_params[:images].each do |image|
      # 既に登録されている画像はスキップさせる（エラー表示はsaveのバリデーション時のみ）
      next if blob_exists?(image, user_checksums)

      build_and_attach_picture(image)
      return false unless @picture.save

      user_checksums << @picture.image.blob.checksum
    end
    true
  end

  def build_and_attach_picture(image)
    @picture = current_user.pictures.build
    @picture.image.attach(image)
    @picture.tempfile_path = image.tempfile.path
  end

  def blob_exists?(image, user_checksums)
    # 保存前にデータベースに同じファイルがないか、checksumの値で確認
    checksum = Digest::MD5.file(image.tempfile.path).base64digest

    user_checksums.include?(checksum)
  end
end
