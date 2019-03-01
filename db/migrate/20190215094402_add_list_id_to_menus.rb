class AddListIdToMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :time, :integer, default: 1
  end
end