class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|

      t.string :company_name
      t.integer :price
      t.integer :market_cap
      t.integer :user_id
      t.string :symbol

      t.timestamps
    end
  end
end
