class Album < ApplicationRecord
  belongs_to :user
  has_many :pages, dependent: :destroy
  after_create :create_initial_page

  validates :title, presence: true, length: { maximum: 50 }
  validates :is_sample, inclusion: { in: [true, false] }

  private

  def create_initial_page
    pages.create(page_number: 1)
  end
end
