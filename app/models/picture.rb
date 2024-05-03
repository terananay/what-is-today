# frozen_string_literal: true

# app/models/picture.rb
class Picture < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :is_sample, inclusion: { in: [true, false] }
  validates :shooting_date, presence: true
  before_validation :set_shooting_date

  private

  def set_shooting_date
    return unless image.attached?

    self.shooting_date = EXIFR::JPEG.new(image.download).date_time_original || Time.current
  end
end
