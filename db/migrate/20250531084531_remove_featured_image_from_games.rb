class RemoveFeaturedImageFromGames < ActiveRecord::Migration[7.2]
  def change
    remove_column :games, :featured_image, :string
  end
end
