class CreateDonations < ActiveRecord::Migration[7.2]
  def change
    create_table :donations do |t|
      t.decimal :amount
      t.string :currency
      t.string :frequency
      t.string :full_name
      t.boolean :subscribe_newsletter
      t.boolean :include_name
      t.string :stripe_session_id
      t.string :stripe_customer_id
      t.string :stripe_payment_id
      t.string :stripe_subscription_id
      t.string :status

      t.timestamps
    end

    add_index :donations, :stripe_session_id, unique: true
  end
end
