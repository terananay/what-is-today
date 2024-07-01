class PagePicturesController < ApplicationController
  def create
    @page_picture = PagePicture.new(page_picture_params)
    if @page_picture.save
      redirect_to page_path(@page_picture.page_id), success: t('flash.page_picture_create')
    else
      flash.now[:danger] = t('flash.page_picture_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def upadate
    @page_picture = PagePicture.find(params[:id])
    if @page_picture.update(page_picture_params)
      redirect_to page_path(@page_picture.page_id), success: t('flash.page_picture_update')
    else
      flash.now[:danger] = t('flash.page_picture_update_failed')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @page_picture = PagePicture.find(params[:id])
    @page_picture.destroy
    redirect_to page_path(@page_picture.page_id), success: t('flash.page_picture_destroy')
  end
end
