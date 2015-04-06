class Admin::DashboardController < Admin::AdminController
  def index
    @models = [User, Category, Book]
  end
end
