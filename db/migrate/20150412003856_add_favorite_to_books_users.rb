class AddFavoriteToBooksUsers < ActiveRecord::Migration
  def change
    add_column :books_users, :favorite, :boolean, :default => false
  end
end
