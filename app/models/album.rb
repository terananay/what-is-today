class Album < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }
  validates :is_sample, inclusion: { in: [true, false] }
end
