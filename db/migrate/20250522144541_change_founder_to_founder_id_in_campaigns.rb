class ChangeFounderToFounderIdInCampaigns < ActiveRecord::Migration[7.2]
  def change
    remove_column :campaigns, :founder, :string
    add_reference :campaigns, :founder, foreign_key: { to_table: :subscribers }
  end
end
