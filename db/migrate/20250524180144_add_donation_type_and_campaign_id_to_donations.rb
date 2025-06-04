class AddDonationTypeAndCampaignIdToDonations < ActiveRecord::Migration[7.2]
  def change
    add_column :donations, :donation_type, :string
    add_reference :donations, :campaign, null: true, foreign_key: true
  end
end
