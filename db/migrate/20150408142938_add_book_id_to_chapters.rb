class AddBookIdToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :book_id, :integer
    add_index :chapters, :book_id
  end
end
