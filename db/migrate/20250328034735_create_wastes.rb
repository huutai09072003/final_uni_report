class CreateWastes < ActiveRecord::Migration[7.2]
  def change
    create_table :wastes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :image
      t.string :type
      t.string :status

      t.timestamps
    end
  end
end
