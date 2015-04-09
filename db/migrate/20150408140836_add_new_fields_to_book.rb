class AddNewFieldsToBook < ActiveRecord::Migration
  def change
    add_column :books, :synopsis, :text, :limit => nil
    add_column :books, :authers, :text
    add_column :books, :duration, :integer
    add_column :books, :target_audience, :text
    add_column :books, :author_bio, :text
  end
end
