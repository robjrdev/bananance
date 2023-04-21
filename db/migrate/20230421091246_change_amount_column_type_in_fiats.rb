class ChangeAmountColumnTypeInFiats < ActiveRecord::Migration[7.0]
  def change
    change_column :fiats, :amount, :decimal, default: 0.0
  end
end
