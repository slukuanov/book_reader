class AddCurrentChapterIdToBooksUsers < ActiveRecord::Migration
  def change
    add_column :books_users, :current_chapter_id, :integer
  end
end
