class AddGameToImages < ActiveRecord::Migration[7.2]
  def change
    add_reference :images, :game, foreign_key: true
  end
end
