class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.string :name
      t.boolean :complete
      t.references :project
      t.references :title

      t.timestamps
    end
  end
end
