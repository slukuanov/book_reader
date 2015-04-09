class Admin::DashboardController < Admin::AdminController
  def index
    # @models = [User, Category, Book]
    redirect_to admin_books_path
  end
end
