class AddSessionIdToDonations < ActiveRecord::Migration[7.2]
  def change
    add_column :donations, :session_id, :string, null: true, default: nil
    add_index :donations, :session_id, unique: true
  end
end
