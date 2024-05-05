# frozen_string_literal: true

# app/models/picture.rb
class Picture < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :is_sample, inclusion: { in: [true, false] }
  validates :shooting_date, presence: true
  attribute :shooting_date, :datetime, default: -> { Time.current }
  # before_validation :set_shooting_date
  validate :image_content_type
  validate :image_size

  private

  def set_shooting_date
    return unless image.attached?

    self.shooting_date = EXIFR::JPEG.new(image.download).date_time_original || Time.current
  end

  def image_content_type
    return unless image.attached? && !image.content_type.in?(%w[image/jpeg image/png])

    errors.add(:image, t('validate.image_type'))
  end

  def image_size
    return unless image.attached? && image.blob.byte_size > 4.megabytes

    errors.add(:image, t('validate.image_size'))
  end
end
