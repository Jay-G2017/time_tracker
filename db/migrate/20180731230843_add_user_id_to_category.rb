class AddUserIdToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :user_id, :bigint
  end
end
