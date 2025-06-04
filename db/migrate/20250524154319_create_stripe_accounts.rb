class CreateStripeAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :stripe_accounts do |t|
      t.references :subscriber, null: false, foreign_key: true
      t.string :stripe_account_id
      t.string :account_type
      t.string :status
      t.string :country
      t.boolean :details_submitted

      t.timestamps
    end
  end
end
