class CreateSubscribers < ActiveRecord::Migration[7.2]
  def change
    create_table :subscribers do |t|
      t.string :nickname
      t.string :full_name
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
