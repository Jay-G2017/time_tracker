class CreateTomatoes < ActiveRecord::Migration[5.2]
  def change
    create_table :tomatoes do |t|
      t.integer :minutes
      t.references :todo

      t.timestamps
    end
  end
end
