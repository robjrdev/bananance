class ChangeStocksColumnNames < ActiveRecord::Migration[7.0]
  def change
    remove_column :stocks, :quantity
    remove_column :stocks, :user_id
    add_column :stocks, :name, :string
  end
end
