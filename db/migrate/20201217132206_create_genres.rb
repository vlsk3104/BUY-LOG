class CreateGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :genres do |t|
      t.string :name
      t.integer :item_id

      t.timestamps
    end
    add_index :genres, :item_id
  end
end
