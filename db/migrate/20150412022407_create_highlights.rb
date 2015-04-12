class CreateHighlights < ActiveRecord::Migration
  def change
    create_table :highlights do |t|
      t.integer :chapter_id
      t.integer :books_user_id
      t.integer :user_id
      t.text :content, :limit => nil
      t.timestamps null: false
    end
  end
end
