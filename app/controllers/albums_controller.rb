class AlbumsController < ApplicationController
  before_action :set_album, only: %i[edit update destroy edit_cancel]

  def index
    @albums = current_user.albums.all
    # index.htmlに新規作成フォームを設定
    @album = Album.new
  end

  def show
    @album = current_user.albums.includes(:pages).find(params[:id])
    @pages = @album.pages
    @page = Page.new
  end

  def edit;end

  def create
    @album = current_user.albums.build(album_params)
    if @album.save
      redirect_to albums_path, success: t('flash.album_create')
    else
      @albums = current_user.albums.all
      flash.now[:danger] = t('flash.album_failed')
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @album.update(album_params)
      flash.now[:success] = t('flash.album_update')
    else
      flash.now[:danger] = t('flash.album_update_failed')
      render :edit
    end
  end

  def destroy
    @album.destroy
    flash.now[:success] = t('flash.album_destroy')
  end

  def edit_cancel
    respond_to :turbo_stream
  end

  private

  def album_params
    params.require(:album).permit(:title)
  end

  def set_album
    @album = current_user.albums.find(params[:id])
  end
end
