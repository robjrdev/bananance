class RenameTransactionTypeToTransactionCategory < ActiveRecord::Migration[7.0]
  def change
    rename_column :transactions, :type, :category
  end
end
