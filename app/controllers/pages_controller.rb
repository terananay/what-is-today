class PagesController < ApplicationController
  before_action :set_album, only: %i[create]
  before_action :set_page, only: %i[show edit update destroy]

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

  def edit;end

  def update
    if @page.update
      redirect_to @page, success: t('flash.page_update')
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

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def set_page
    @page = Page.find(params[:id])
  end

end
