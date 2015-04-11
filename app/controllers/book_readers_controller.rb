class BookReadersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:read]
  layout "reader"

  def read
    @user_book = current_user.user_book(@book.id)
    if @user_book.blank?
      @user_book = BooksUser.create(book_id: @book.id, user_id: current_user.id, current_chapter_id: @book.chapters.first.id)
    end
  end

  def update_current_chapter
    @user_book = BooksUser.find_by_id(book_user_params[:id])
    if @user_book.update(book_user_params)
      render :json => true
    else
      render :json => { status: 403 }
    end
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end

  def book_user_params
    params.require(:books_user).permit(:id, :current_chapter_id)
  end
end
