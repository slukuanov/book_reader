class AddNewFields1ToBooks < ActiveRecord::Migration
  def change
    add_column :books, :image, :string
    add_column :books, :crop_x, :string
    add_column :books, :crop_y, :string
    add_column :books, :crop_w, :string
    add_column :books, :crop_h, :string
    add_column :books, :temp_image, :string
  end
end
