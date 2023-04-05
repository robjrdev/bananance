class RenameIsadminColumnInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :isadmin, :admin
  end
end
