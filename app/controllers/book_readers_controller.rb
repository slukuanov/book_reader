class BookReadersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:read]
  layout "reader"

  def read
    unless current_user.has_free_tariff
      @user_book = current_user.user_book(@book.id)
      if @user_book.blank?
        @user_book = BooksUser.create(book_id: @book.id, user_id: current_user.id, current_chapter_id: @book.chapters.first.id)
      end

      if params[:chapter_id].present?
        @user_book.current_chapter_id = params[:chapter_id]
        @user_book.save
      end
    else
      redirect_to root_path
    end
  end

  def update_book
    @user_book = BooksUser.find_by_id(book_user_params[:id])
    if @user_book.update(book_user_params)
      render :json => true
    else
      render :json => { status: 403 }
    end
  end

  def save_highlighter
    if Highlight.create(highlighter_params.merge!({user_id: current_user.id}))
      render :json => true
    else
      render :json => { status: 403 }
    end
  end

  def remove_highlighter
    Highlight.where(highlighter_params).destroy_all

    render :json => true
  end

  def get_highlighters
    @user_book = BooksUser.find_by_id(book_user_params[:id])
    @highlighters = Highlight.where(books_user_id: @user_book.id)

    render :json => @highlighters.to_json
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end

  def book_user_params
    params.require(:books_user).permit(:id, :current_chapter_id, :favorite)
  end

  def highlighter_params
    params.require(:highlight).permit(:id, :chapter_id, :books_user_id, :content, :user_id)
  end
end
