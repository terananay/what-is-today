# frozen_string_literal: true

# controllers/pictures_controller.rb
class PicturesController < ApplicationController
  before_action :set_picture, only: %i[show edit edit_cancel update destroy]
  before_action :search_poictures, only: %i[index daily_pictures]
  after_action :store_pictures_in_session, only: %i[daily_pictures]

  def new
    @picture = Picture.new
  end

  def index; end

  def show; end

  def edit
    @is_show_page = params[:from] == 'show'
    @is_index_page = params[:from] == 'index'
    respond_to :turbo_stream
  end

  def edit_cancel
    @is_show_page = params[:from] == 'show'
    @is_index_page = params[:from] == 'index'
    respond_to :turbo_stream
  end

  def create
    user_checksums = current_user.pictures.checksums.pluck('active_storage_blobs.checksum')
    if process_images(user_checksums)
      redirect_to daily_pictures_pictures_path, success: t('flash.picture_create')
    else
      flash.now[:error] = t('flash.picture_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @picture.update(picture_params)
    @is_show_page = params[:picture][:from] == 'show'
    @is_index_page = params[:picture][:from] == 'index'
    respond_to :turbo_stream
  end

  def destroy
    @picture.destroy
    flash.now[:success] = t('flash.delete')
    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to pictures_path, status: :see_other }
    end
  end

  def daily_pictures
    # 基本表示のクエリ
    result = current_user.pictures.base_scope_and_title
    @title = result[:title]
    base_scope = result[:base_scope]

    # 検索がなければ基本を表示
    search_results_or_base(base_scope)
    # 年毎に表示
    @pictures_by_year = @pictures.order(shooting_date: :desc).group_by { |picture| picture.shooting_date.year }
  end

  def slide_show
    if session[:pictures_by_year].present?
      @pictures = Picture.where(id: session[:pictures_by_year])

      # クリックしたpictureのidを取得
      clicked_picture_id = params[:id].to_i

      # クリックしたpictureを先頭に持ってくる
      @pictures = @pictures.sort_by { |picture| picture.id == clicked_picture_id ? 0 : 1 }
    end
  end

  private

  def picture_params
    params.require(:picture).permit(:title, :memo, images: [])
  end

  def set_picture
    @picture = current_user.pictures.find(params[:id])
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

  def search_poictures
    if params[:q].present? && params[:q][:title_or_memo_cont_any].present?
      if params[:q][:title_or_memo_cont_any].is_a?(String)
        params[:q][:title_or_memo_cont_any] = params[:q][:title_or_memo_cont_any].split(/[\p{blank}\s]+/)
      end
      @q = current_user.pictures.ransack(params[:q])
      @pictures = @q.result(distinct: true).with_attached_image.page(params[:page]).per(20)
    else
      @q = current_user.pictures.ransack(params[:q])
      @pictures = @q.result(distinct: true).with_attached_image.page(params[:page]).per(20)
    end
  end

  def search_results_or_base(base_scope)
    if params[:q].blank? || params[:q][:title_or_memo_cont_any].blank?
      @q = base_scope.ransack(params[:q])
      @pictures = @q.result.with_attached_image.page(params[:page]).per(20)
    else
      @title = nil
    end
  end

  def store_pictures_in_session
    session[:pictures_by_year] = @pictures.pluck(:id) if @pictures.present?
  end
end
