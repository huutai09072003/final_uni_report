class CreateItemRelationships < ActiveRecord::Migration[7.2]
  def change
    create_table :item_relationships do |t|
      t.references :item, foreign_key: true
      t.references :related_item, foreign_key: { to_table: :items }


      t.timestamps
    end
  end
end
