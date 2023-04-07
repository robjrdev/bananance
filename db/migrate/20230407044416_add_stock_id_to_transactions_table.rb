class AddStockIdToTransactionsTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :transactions, :stock, foreign_key: true
  end
end
