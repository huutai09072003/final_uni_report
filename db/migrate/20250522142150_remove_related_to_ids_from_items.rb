class RemoveRelatedToIdsFromItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :items, :related_to_ids, :integer
  end
end
