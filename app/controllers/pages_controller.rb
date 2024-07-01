class PagesController < ApplicationController
  before_action :set_album, only: %i[create]
  before_action :set_page, only: %i[show edit update destroy]
  before_action :set_page_pictures, only: %i[show edit]

  def create
    @page = @album.pages.build
    last_page_number = @album.pages.maximum(:page_number)
    # アルバムの最後のページ番号を取得
    @page.page_number = last_page_number + 1

    if @page.save
      redirect_to page_path(@page), success: t('flash.page_create')
    else
      flash.now[:danger] = t('flash.page_failed')
      render album_path(@album), status: :unprocessable_entity
    end
  end

  def show;end

  def edit
    # アルバムに含まれているpicture_idを取得
    included_picture_ids = Page.album_picture_ids(params[:page_id])
    @pictures = current_user.pictures.includes(image_attachment: :blob)
    # 取得したpicture_idの配列を除外して@picturesを取得
    @pictures = @pictures.where.not(id: included_picture_ids)
  end

  def update
    if save_page_pictures
      redirect_to page_path(@page), success: t('flash.page_update')
    else
      flash.now[:danger] = t('flash.page_update_failed')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    album_id = @page.album_id
    @page.destroy
    redirect_to album_path(album_id), success: t('flash.page_destroy')
  end

  private

  def page_params
    params.require(:page).permit(picture_ids: [])
  end

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def set_page
    @page = Page.find(params[:id])
  end

  def set_page_pictures
    @page_pictures = @page.page_pictures.includes(picture: { image_attachment: :blob }).order(:position)
  end

  def save_page_pictures
    picture_ids = page_params["picture_ids"].first.split(',').map(&:to_i)
    picture_ids.each_with_index do |id, index|
      position = index + 1
      existing_page_pictures = PagePicture.find_by(page_id: params[:id], position: position)

      if existing_page_pictures
        unless existing_page_pictures.update(picture_id: id)
          return false
        end
      else
        unless @page.page_pictures.create(page_id: params[:page_id], picture_id: id, position: position)
          return false
        end
      end
    end
    true
  end

end
