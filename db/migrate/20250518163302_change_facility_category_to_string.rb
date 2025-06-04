class ChangeFacilityCategoryToString < ActiveRecord::Migration[7.2]
  def up
    change_column :facilities, :category, :string, using: 'category::text'
  end

  def down
    change_column :facilities, :category, :integer, using: 'category::integer'
  end
end
