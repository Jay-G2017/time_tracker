class AddPinToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :pin, :boolean
  end
end
