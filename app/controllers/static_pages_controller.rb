# frozen_string_literal: true

# controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController
  skip_before_action :require_login
  def about; end
end
