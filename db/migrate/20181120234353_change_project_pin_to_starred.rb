class ChangeProjectPinToStarred < ActiveRecord::Migration[5.2]
  def change
    rename_column :projects, :pin, :starred
  end
end
