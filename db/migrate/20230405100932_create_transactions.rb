class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :symbol
      t.decimal :quantity
      t.references :user, null: false, foreign_key: true
      t.string :transaction_type
      t.decimal :price_per_quantity

      t.timestamps
    end
  end
end
