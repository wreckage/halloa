class AddGravatarIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :gravatar_id, :string
  end
end
