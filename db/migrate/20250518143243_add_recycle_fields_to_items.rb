class AddRecycleFieldsToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :can_recycle, :boolean
    add_column :items, :life_cycle, :text
    add_column :items, :recycle_way, :text
  end
end
