class CreateFacilities < ActiveRecord::Migration[7.2]
  def change
    create_table :facilities do |t|
      t.string :name
      t.integer :category
      t.string :link

      t.timestamps
    end
  end
end
