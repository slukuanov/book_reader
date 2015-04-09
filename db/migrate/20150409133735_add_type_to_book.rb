class AddTypeToBook < ActiveRecord::Migration
  def change
    add_column :books, :book_type, :integer, default: 0
  end
end
