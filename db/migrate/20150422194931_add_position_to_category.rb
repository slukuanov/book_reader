class AddPositionToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :row_order, :integer, default: 0
  end
end
