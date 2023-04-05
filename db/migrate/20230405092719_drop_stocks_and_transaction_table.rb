class DropStocksAndTransactionTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :stocks
    drop_table :transactions
  end
end
