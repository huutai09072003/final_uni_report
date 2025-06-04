class RemoveSlugFromItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :items, :slug, :string
  end
end
