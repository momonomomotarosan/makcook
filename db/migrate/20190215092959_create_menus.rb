class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.references :user
      t.string :title
      t.timestamps null: false
      t.boolean :completed
      t.string :material
      t.string :howto
      t.boolean :star
      t.integer :list_id, default: 1
    end
  end
end