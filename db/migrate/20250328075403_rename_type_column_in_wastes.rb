class RenameTypeColumnInWastes < ActiveRecord::Migration[7.2]
  def change
    rename_column :wastes, :type, :waste_type
  end
end
