class CreateStations < ActiveRecord::Migration[7.2]
  def change
    create_table :stations do |t|
      t.string :name
      t.string :location
      t.string :password_digest

      t.timestamps
    end
  end
end
