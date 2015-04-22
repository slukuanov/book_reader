class Admin::CategoriesController < Admin::AdminController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :move]
  skip_before_filter :verify_authenticity_token, only: [:search]

  def index
    @categories = Category.rank(:row_order).all
    respond_to do |format|
      format.html
    end
  end

  def sort_by_id
    @categories = Category.sort_by_id
    render "index"
  end

  def search
    @search_query = params[:search_query]
    @categories = Category.search(@search_query)
    render 'index'
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      @category.update_attribute :row_order_position, :last
      redirect_to [:admin, @category], notice: 'Category was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
    if @category.update(category_params)
      redirect_to admin_category_path(@category), success: 'Update success'
    else
      render "edit"
    end
  end

  def destroy
    if @category.destroy
      redirect_to :action => "index"
    else
      redirect_to :action => "index"
    end
  end

  def move
    @category.update_attribute :row_order_position, params[:position]
    redirect_to admin_categories_path, success: 'Update success'
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:title, :row_order)
    end
end
