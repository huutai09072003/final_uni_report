class AddRelatedToIdToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :related_to_ids, :integer, array: true, default: []  
  end
end
