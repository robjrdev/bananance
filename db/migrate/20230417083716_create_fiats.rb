class CreateFiats < ActiveRecord::Migration[7.0]
  def change
    create_table :fiats do |t|
      t.string :type
      t.integer :amount, default: 0
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
