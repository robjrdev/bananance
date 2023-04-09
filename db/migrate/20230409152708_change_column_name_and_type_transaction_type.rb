class ChangeColumnNameAndTypeTransactionType < ActiveRecord::Migration[7.0]
  def change
    change_column :transactions,
                  :transaction_type,
                  'integer USING CAST(transaction_type AS integer)'
    rename_column :transactions, :transaction_type, :type
  end
end
