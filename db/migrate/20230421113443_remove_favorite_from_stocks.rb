class RemoveFavoriteFromStocks < ActiveRecord::Migration[7.0]
  def change
    remove_column :stocks, :favorite, :boolean
  end
end
