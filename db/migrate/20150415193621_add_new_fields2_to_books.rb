class AddNewFields2ToBooks < ActiveRecord::Migration
  def change
    add_column :books, :on_front_page, :boolean, default: false
    add_column :books, :is_free, :boolean, default: false
  end
end
