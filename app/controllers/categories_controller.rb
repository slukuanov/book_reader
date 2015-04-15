class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def show
    @books =
      if user_signed_in? && current_user.tariff_type == 0
        @category.books.where(is_free: true)
      else
        @category.books
      end
    render template: "books/index"
  end

  private
  def set_category
    @category = Category.find_by_title(params[:id])
  end
end