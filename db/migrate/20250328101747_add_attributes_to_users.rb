class AddAttributesToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    add_column :users, :location, :string
    add_column :users, :points, :integer
    add_column :users, :role, :string
    add_column :users, :recycling_goal, :integer
  end
end
