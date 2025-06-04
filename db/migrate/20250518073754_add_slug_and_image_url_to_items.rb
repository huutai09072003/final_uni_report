class AddSlugAndImageUrlToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :slug, :string
    add_column :items, :image_url, :string
  end
end
