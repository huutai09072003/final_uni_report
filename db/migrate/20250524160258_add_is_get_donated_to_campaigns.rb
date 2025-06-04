class AddIsGetDonatedToCampaigns < ActiveRecord::Migration[7.2]
  def change
    add_column :campaigns, :is_get_donated, :boolean
  end
end
