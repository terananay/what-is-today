# frozen_string_literal: true

# app/models/authentication.rb
class Authentication < ApplicationRecord
  belongs_to :user
end
