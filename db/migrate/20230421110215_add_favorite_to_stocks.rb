class AddFavoriteToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :favorite, :boolean, default: false
  end
end
