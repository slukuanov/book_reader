class WelcomeController < ApplicationController
  def index
    @books = if user_signed_in? && current_user.tariff_type == 0
      Book.where(is_free: true, on_front_page: true)
    else
      Book.where(on_front_page: true)
    end
  end
end
