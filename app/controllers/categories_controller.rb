class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def show
    @books = @category.books
    render template: "books/index"
  end

  private
  def set_category
    @category = Category.find_by_id(params[:id])
  end
end