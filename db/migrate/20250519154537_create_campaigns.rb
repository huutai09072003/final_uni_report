class CreateCampaigns < ActiveRecord::Migration[7.2]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :description
      t.string :status
      t.bigint :subscriber_ids, array: true, default: []

      t.timestamps
    end
  end
end
