class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string :name
      t.string :description
      t.string :featured_image

      t.timestamps
    end
  end
end
