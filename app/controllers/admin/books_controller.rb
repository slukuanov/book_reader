class Admin::BooksController < Admin::AdminController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:search]

  def index
    @books = Book.all
    respond_to do |format|
      format.html
    end
  end

  def sort_by_id
    @books = Book.sort_by_id
    render "index"
  end

  def search
    @search_query = params[:search_query]
    @books = Book.search(@search_query)
    render 'index'
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to [:admin, @book], notice: 'Book was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
    if @book.update(book_params)
      redirect_to admin_book_path(@book), success: 'Update success'
    else
      render "edit"
    end
  end

  def destroy
    if @book.destroy
      redirect_to :action => "index"
    else
      redirect_to :action => "index"
    end
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, {category_ids: []})
    end
end
