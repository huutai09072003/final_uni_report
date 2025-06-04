class AddNameToBloggers < ActiveRecord::Migration[7.2]
  def change
    add_column :bloggers, :username, :string
  end
end
