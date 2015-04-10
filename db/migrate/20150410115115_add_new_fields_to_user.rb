class AddNewFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :tariff_type, :integer, default: 0
    add_column :users, :expire_date, :date
  end
end
