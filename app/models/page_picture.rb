# app/models/page_picture.rb
class PagePicture < ApplicationRecord
  belongs_to :page
  belongs_to :picture

  validates :position, presence: true
  validates :page_id, uniqueness: { scope: :picture_id }
  validates :position, inclusion: { in: [1, 2] }
  validate :picture_uniqueness_in_album

  private

  def picture_uniqueness_in_album
    # pageのalbum_idを取得
    album_id = Page.where(id: self.page_id).pluck(:album_id).first
    # 同じalbumに属する全てのpagesを通じて、同じpictureが既に使われているかチェック
    album_picture_ids = Album.joins(pages: { page_pictures: :picture }).where(albums: {id: album_id}).pluck('pictures.id')
    if album_picture_ids.include?(self.picture_id)
      errors.add(:picture, I18n.t('validate.used_picture'))
    end
  end
end
