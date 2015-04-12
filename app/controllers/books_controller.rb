class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:favorite_list, :highlight_list, :delete_highlight, :add_comment_to_highlighter]
  before_action :set_book, only: [:show]

  def index
    @books = Book.all
  end

  def show
  end

  def highlight_list
    @highlightes = current_user.highlights
  end

  def favorite_list
    @books = current_user.books.where('books_users.favorite = ?', true)

    render template: "books/index"
  end

  def delete_highlight
    Highlight.find_by_id(params[:id]).destroy

    redirect_to user_highlight_list_path
  end

  def add_comment_to_highlighter
    commentable = Highlight.find_by_id(params[:id])
    if commentable.comments.create(comment_params.merge!({user_id: current_user.id}))
      render :json => true
    else
      render :json => { status: 403 }
    end
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment, :title, :user_id, :commentable_id, :commentable_type, :role)
  end
end