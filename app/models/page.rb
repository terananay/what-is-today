class Page < ApplicationRecord
  belongs_to :album

  validates :page_number, presence: true
  validates :is_sample, inclusion: { in: [true, false] }
  validates :album_id, uniqueness: { scope: :page_number }
end
