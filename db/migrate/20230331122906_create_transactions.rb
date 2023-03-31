class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|

      t.integer :share
      t.integer :price
      t.decimal :value
      t.integer :stock_id
      t.string :transaction_type

      t.timestamps
    end
  end
end
