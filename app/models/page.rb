# app/models/page.rb
class Page < ApplicationRecord
  belongs_to :album
  has_many :page_pictures
  has_many :pictures, through: :page_pictures

  validates :page_number, presence: true
  validates :is_sample, inclusion: { in: [true, false] }
  validates :album_id, uniqueness: { scope: :page_number }

  private

  def self.album_picture_ids(page_id)
    # pageのalbum_idを取得
    album_id = where(id: page_id).pluck(:album_id).first
    # 同じalbumに属する全てのpagesの、picture_idを取得
    album_picture_ids = Album.joins(pages: :pictures).where(albums: {id: album_id}).pluck('pictures.id')
  end
end
