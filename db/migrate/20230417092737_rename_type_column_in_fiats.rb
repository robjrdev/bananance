class RenameTypeColumnInFiats < ActiveRecord::Migration[7.0]
  def change
    rename_column :fiats, :type, :transaction_type
  end
end
