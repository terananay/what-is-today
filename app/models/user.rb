# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications
  has_many :pictures, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :is_guest, inclusion: { in: [true, false] }
  # ユーザーの新規作成時にis_guestはデフォルトでfalseを自動登録する
  before_validation :set_default_is_guest, on: :create

  private

  def set_default_is_guest
    self.is_guest = false if is_guest.nil?
  end
end
