class CreateParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :participants do |t|
      t.references :subscriber, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
