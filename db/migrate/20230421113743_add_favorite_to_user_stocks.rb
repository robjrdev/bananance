class AddFavoriteToUserStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :user_stocks, :favorite, :boolean, default: false
  end
end
