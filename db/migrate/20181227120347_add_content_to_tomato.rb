class AddContentToTomato < ActiveRecord::Migration[5.2]
  def change
    add_column :tomatoes, :content, :text
  end
end
