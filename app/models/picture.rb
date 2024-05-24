# frozen_string_literal: true
require 'mini_exiftool'

# app/models/picture.rb
class Picture < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, length: { maximum: 25 }
  validates :memo, length: { maximum: 200 }
  validates :is_sample, inclusion: { in: [true, false] }
  validates :shooting_date, presence: true
  attribute :shooting_date, :datetime, default: -> { Time.current }
  validate :image_content_type
  validate :image_size
  validate :image_attached

  before_save :shooting_date_set

  scope :checksums, -> { joins(image_attachment: :blob) }
  scope :desc, -> { order(created_at: :desc) }

  attr_accessor :tempfile_path

  private

  def shooting_date_set
    return unless image.attached?

    self.shooting_date = MiniExiftool.new(tempfile_path).create_date || Time.current
  end

  def image_content_type
    return unless image.attached? && !image.content_type.in?(%w[image/jpeg image/png])

    errors.add(:image, I18n.t('validate.image_type'))
  end

  def image_size
    return unless image.attached? && image.blob.byte_size > 4.megabytes

    errors.add(:image, I18n.t('validate.image_size'))
  end

  def image_attached
    errors.add(:image, I18n.t('validate.image_blank')) unless image.attached?
  end
end
