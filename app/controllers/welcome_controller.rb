class WelcomeController < ApplicationController
  def index
    @books = Book.where(on_front_page: true)
  end
end
