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
  attribute :shooting_date, :datetime, default: -> { Time.zone.now }
  validate :image_content_type
  validate :image_size
  validate :image_attached

  before_save :shooting_date_set

  scope :checksums, -> { joins(image_attachment: :blob) }
  scope :allyears_on_same_date, lambda {
    where(
      'EXTRACT(MONTH FROM shooting_date) = ? AND EXTRACT(DAY FROM shooting_date) = ?',
      Date.today.month,
      Date.today.day
    )
  }
  scope :allyears_on_same_month, -> { where('EXTRACT(MONTH FROM shooting_date) = ?', Date.today.month) }

  attr_accessor :tempfile_path

  def self.ransackable_attributes(_auth_object = nil)
    %w[title memo shooting_date created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def self.base_scope_and_title
    if allyears_on_same_date.empty?
      base_scope = allyears_on_same_month
      title = "#{Date.today.month}月"
    else
      base_scope = allyears_on_same_date
      title = "#{Date.today.month}月 #{Date.today.day}日"
    end
    { base_scope:, title: }
  end

  private

  def shooting_date_set
    return unless image.attached?

    tokyo_time = ActiveSupport::TimeZone['Tokyo']
    self.shooting_date = MiniExiftool.new(tempfile_path).create_date || tokyo_time.now
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
