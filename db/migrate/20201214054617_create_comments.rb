class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :item_id
      t.integer :user_id
      t.text :content
      t.timestamps
    end
    add_index :comments, :user_id  
    add_index :comments, :item_id
  end
end
