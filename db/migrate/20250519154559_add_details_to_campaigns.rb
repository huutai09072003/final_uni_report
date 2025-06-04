class AddDetailsToCampaigns < ActiveRecord::Migration[7.2]
  def change
    add_column :campaigns, :thumb_nail_url, :string
    add_column :campaigns, :goal, :string
    add_column :campaigns, :location, :string
    add_column :campaigns, :founder, :string
  end
end
