class AddLoginatToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :login_at, :datetime
  end
end
