class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :name, :username
    add_index :users, :username, unique: true
  end
end
